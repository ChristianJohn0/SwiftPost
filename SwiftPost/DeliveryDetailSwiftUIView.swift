//
//  DeliveryDetailSwiftUIView.swift
//  SwiftPost
//
//  Created by Christian John on 2022-04-01.
//

import SwiftUI

struct DeliveryDetailSwiftUIView: View {
    @State private var model = Tracker()
    @State private var trackingDetails = [FinalTrackingDetail]()
    @State private var detailsAvailable = false
    
    @State private var originLocation = ""
    @State private var destinationLocation = ""
    
    @State private var showAlert = false
    
    private let trackingCode: String
    private let deliveryService: DeliveryService
    private let url: String
    
    init(code: String, service: DeliveryService) {
        self.trackingCode = code
        self.deliveryService = service
        self.url = String.generateTrackingURL(using: code, delivery: service)
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        ZStack {
            Color.applicationColor.ignoresSafeArea()
            VStack {
                if !detailsAvailable {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else {
                    Image(deliveryService.id)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Text(model.tracking_code ?? "Sorry an issue was encountered. You need a tracking code!!!")
                        .font(.title2)
                        .fontWeight(.heavy)
                    
                    if let status = model.status {
                        if let temporaryDeliveryState = DeliveryState(rawValue: status) {
                            DeliveryProgressView(using: temporaryDeliveryState)
                                .padding()
                            Text("\(temporaryDeliveryState.rawValue)".localizedCapitalized)
                                .padding(.bottom)
                        }
                    }
                    
                    VStack {
                        HStack {
                            VStack {
                                Text("From").fontWeight(.semibold)
                                Text(originLocation).foregroundColor(Color.gray)
                            }
                            Spacer()
                            VStack {
                                Text("To").fontWeight(.semibold)
                                Text(destinationLocation).foregroundColor(Color.gray)
                            }
                        }
                        .padding(.bottom)
                        
                        if model.finalized == false {
                            if let estimatedDate = model.carrier_detail?.est_delivery_date_local,
                               let estimatedTime = model.carrier_detail?.est_delivery_time_local {
                                Text("Estimated Delivery Date: " + Miscellaneous().getEstimatedDateTime(date: estimatedDate, dateFormat: "yyyy-MM-dd", time: estimatedTime, timeFormat: "HH:mm:ss"))
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            } else if let estimatedDateTime = model.est_delivery_date {
                                Text("Estimated Delivery Date: " + Miscellaneous().getEstimatedDateTime(dateTime: estimatedDateTime, dateTimeFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'" ))
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            }
                        }
                        else if trackingDetails != [] {
                            Text("Delivered: \(trackingDetails[0].localDateTime, formatter: DateFormatter.mediumDateTimeFormatter)")
                                .foregroundColor(.gray)
                                .padding(.bottom)
                        }
                        
                        Text("Delivery progress").font(.headline).fontWeight(.heavy)
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(trackingDetails) { element in
                            VStack(alignment: .leading) {
                                Text("\(element.localDateTime, formatter: DateFormatter.mediumDateFormatter)")
                                    .fontWeight(.semibold)
                                    .padding(.bottom)
                                
                                Text("\(element.localDateTime, formatter: DateFormatter.shortTimeFormatter)")
                                    .foregroundColor(.gray)
                                
                                Text(element.trackingDetail.message ?? "No messages found")
                                    .foregroundColor(.gray)
                                
                                if let location = element.trackingDetail.tracking_location {
                                    if let city = location.city, let state = location.state {
                                        Text(city.localizedCapitalized + ", " + state).foregroundColor(.gray)
                                    } else {
                                        Text(originLocation).foregroundColor(.gray)
                                    }
                                }
                            }
                            .listRowBackground(Color.applicationColor)
                        }
                    }
                    .listStyle(InsetListStyle())
                    .onAppear() {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    }
                }
            } // End VStack
            .font(.callout)
            .onAppear() {
                TrackerAPI().getTrackingDataFromAPINew(from: url) { (response) in
                    self.model = response
                    
                    if let origin = model.carrier_detail?.origin_location {
                        Miscellaneous().getFullAddress(address: origin) { (location, error) in
                            if error != nil { print(error?.localizedDescription as Any) }
                            originLocation = location ?? ""
                            
                            TrackerAPI().getFinalTrackingDetails(from: model.tracking_details, origin: originLocation) { (details) in
                                trackingDetails = details
                                detailsAvailable = true
                            }
                        }
                    }
                    
                    if let destination = model.carrier_detail?.destination_location {
                        Miscellaneous().getFullAddress(address: destination) { (location, error) in
                            if error != nil { print(error?.localizedDescription as Any) }
                            destinationLocation = location ?? ""
                        }
                    }
                }
            }
            .navigationBarItems(trailing: Button(action:  addItem, label: { Image(systemName: "plus") }))
            .alert(isPresented: $showAlert) {
                return Alert(title: Text("Delivery Detail Saved"),
                             message: Text("Your delivery details have been saved. You can access this information from the home screen."),
                             dismissButton: .default(Text("OK")))
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }   // End Body View
    
    private func addItem() {
        showAlert = true
        withAnimation {
            if detailsAvailable {
                if items.filter({ $0.code == model.tracking_code }).count > 0 {
                    for item in items {
                        if item.code == model.tracking_code {
                            item.timestamp = Date()
                            item.code = model.tracking_code
                            item.service = String(describing: deliveryService)
                            item.message = trackingDetails[0].trackingDetail.message
                            if let location = trackingDetails[0].trackingDetail.tracking_location {
                                if let city = location.city, let state = location.state {
                                    item.address = city.localizedCapitalized + ", " + state
                                }
                            }
                        }
                    }
                } else {
                    let newItem = Item(context: viewContext)
                    
                    newItem.timestamp = Date()
                    newItem.code = model.tracking_code
                    newItem.service = String(describing: deliveryService)
                    newItem.message = trackingDetails[0].trackingDetail.message
                    if let location = trackingDetails[0].trackingDetail.tracking_location {
                        if let city = location.city, let state = location.state {
                            newItem.address = city.localizedCapitalized + ", " + state
                        }
                    }
                }
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
}

struct DeliveryDetailSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            DeliveryDetailSwiftUIView(code: "955110620106", service: DeliveryService.FedEx)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}

