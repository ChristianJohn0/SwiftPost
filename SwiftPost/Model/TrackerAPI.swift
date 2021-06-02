//
//  TrackerAPI.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import Foundation

class TrackerAPI {

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

