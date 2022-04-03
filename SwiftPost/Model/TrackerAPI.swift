//
//  TrackerAPI.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import Foundation

class TrackerAPI {

    func getTrackingDataFromAPINew(from url: String, completionHandler: @escaping ((Tracker) -> Void)) {
        let token = "EZTK2b2b7bf3cfcb44bbaa40f92ce17cefd4ugztu0HLDrONTSbPqwECBg"
        guard let url = URL(string: "https://api.easypost.com/v2/trackers?tracker[tracking_code]=EZ1000000001&tracker[carrier]=FedEx") else {
            print("Invalid URL")
            exit(0)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Tracker.self, from: data) {
                    completionHandler(decodedResponse)
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unable to retrive data")")
        }.resume()
    }
    
    func getTrackingDataFromAPI(from url: String, completionHandler: @escaping (([Tracker]) -> Void)) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Tracker].self, from: data) {
                    completionHandler(decodedResponse)
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func getFinalTrackingDetails(from modelDetails: [Tracking_Details]?, origin: String, completion: @escaping (([FinalTrackingDetail]) -> Void)) {
        var trackingDetails = [FinalTrackingDetail]()
        
        if let details = modelDetails {
            for detail in details {
                if let date = detail.datetime,
                   let location = detail.tracking_location {
                    var address = ""
                    if let city = location.city, let state = location.state {
                        address = city.localizedCapitalized + ", " + state
                    } else {
                        address = origin
                    }
                    
                    Miscellaneous().getLocalDateTime(date: date, address: address) { (localDateTime) in
                        trackingDetails.append(FinalTrackingDetail(detail: detail, date: localDateTime))
                        trackingDetails = trackingDetails.sorted(by: { $0.localDateTime.compare($1.localDateTime) == .orderedDescending })
                        completion(trackingDetails)
                    }
                }
            }
        }
    }
    
}

