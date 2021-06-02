//
//  HomeView.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import SwiftUI

struct HomeView: View {
    @State private var trackingCode = ""
    @State private var deliveryService = DeliveryService.CanadaPost
    @State private var services: [DeliveryService] = []
    @State private var selection: FetchedResults<Item>.Element?
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
                  animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.applicationColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Image("HomeScreenIcon")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)

                    TextField("Track Delivery", text: $trackingCode)
                        .padding(.all, 3.0)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.applicationColor))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 1))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .font(.callout)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    Text("Select Your Delivery Service")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding(.top)

                    Picker("Service", selection: $deliveryService) {
                        ForEach(services) { service in
                            Text("\(service.id)").tag(service).font(.callout)
                        }
                    }

                    NavigationLink(
                        destination: DeliveryDetailView(code: trackingCode, service: deliveryService),
                        label: {
                            Text("Navigate")
                                .frame(width: 150, height: 40, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Capsule(style: .circular)
                                                .fill(LinearGradient(gradient: Gradient(colors: [.applicationGradientColorOne, .applicationGradientColorTwo]), startPoint: .top, endPoint: .bottom)))
                        })
                    
                    if items.count > 0 {
                        Text("History")
                            .fontWeight(.semibold)
                            .padding(.top)
                        
                        List {
                            ForEach(items) { item in
                                NavigationLink(
                                    destination: DeliveryDetailView(code: item.code!, service: DeliveryService(rawValue: item.service!) ?? DeliveryService.CanadaPost)) {
                                    VStack(alignment: .leading) {
                                        Text(item.code ?? "nil")
                                            .fontWeight(.semibold)
                                        Text("Last viewed: \(item.timestamp ?? Date(), formatter: DateFormatter.mediumDateTimeFormatter)")
                                            .foregroundColor(.gray)
                                        Text(item.message ?? "nil")
                                            .foregroundColor(.gray)
                                        Text(item.address ?? "nil")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .font(.callout)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(InsetListStyle())
                        .onAppear() {
                            UITableViewCell.appearance().backgroundColor = .clear
                            UITableView.appearance().backgroundColor = .clear
                        }
                        .onDisappear() {
                            UITableViewCell.appearance().selectionStyle = .none
                            UITableViewCell.appearance().selectionStyle = .gray

                            UITableView.appearance().separatorStyle = .singleLine
                        }
                    }
                }   // End VStack
                .padding(50)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
            }   // End ZStack
        }   // End NavigationView
        .colorScheme(.dark)
        .onAppear(perform: {
            services = Miscellaneous().getDeliveryService()
        })
    }   // End Body
        
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
    
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



//            .onTapGesture {
//                self.endTextEditing()
//            }
