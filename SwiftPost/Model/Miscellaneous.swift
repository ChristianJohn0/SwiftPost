//
//  Miscellaneous.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import CoreLocation
import SwiftUI

class Miscellaneous {
    
    func getTimeZoneFrom(address: String, completion: @escaping(_ coordinate: String?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.timeZone?.identifier, $1) }
    }

    func calculateLocalDateTime(from date: String, identifier: String, using format: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = format
        
        if let date = formatter.date(from: date) {
            if let timeInterval = TimeZone.init(identifier: identifier)?.secondsFromGMT(for: date) {
                let localDateTime = Date(timeInterval: TimeInterval(timeInterval), since: date)
                return localDateTime
            }
        } else {
            print("Cannot get the date using the provided date format.\nPlease provide adequate date format.")
            return Date()
        }
        return Date()
    }

    func getLocalDateTime(date: String, address: String, completionHandler: @escaping ((Date) -> Void)) {
        getTimeZoneFrom(address: address) { [self] (timeZoneIdentifier, error) in
            guard let identifier = timeZoneIdentifier, error == nil else { return }
            let localDateTime = calculateLocalDateTime(from: date, identifier: identifier, using: "yyyy-MM-dd'T'HH:mm:ss'Z'")
            
            completionHandler(localDateTime)
        }
    }
    
    func getFullAddress(address: String, completion: @escaping(_ location: String?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) {
            let location = ["\($0?.first?.locality ?? "")", "\($0?.first?.administrativeArea ?? "")", "\($0?.first?.isoCountryCode ?? "")"]
            completion(location.filter { $0 != "" }.joined(separator: ", "), $1)
        }
    }
    
    func getEstimatedDateTime(date: String, dateFormat: String, time: String, timeFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = dateFormat + timeFormat
        
        if let dateTime = formatter.date(from: date + time) {
            return DateFormatter.localizedString(from: dateTime, dateStyle: .medium, timeStyle: .short)
        }
        return "Coudn't get the date using the provided format"
    }
    
    func getEstimatedDateTime(dateTime: String, dateTimeFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = dateTimeFormat
        
        if let temp = formatter.date(from: dateTime) {
            return DateFormatter.localizedString(from: temp, dateStyle: .medium, timeStyle: .short)
        }
        return "Coudn't get the date using the provided format"
    }

    func dateTimeUsingMediumFormat(provided dateTime: Date) -> String {
        return DateFormatter.localizedString(from: dateTime, dateStyle: .medium, timeStyle: .short)
    }
    
    func dateUsingMediumFormat(provided dateTime: Date) -> String {
        return DateFormatter.localizedString(from: dateTime, dateStyle: .medium, timeStyle: .none)
    }
    
    func timeUsingShortFormat(provided dateTime: Date) -> String {
        return DateFormatter.localizedString(from: dateTime, dateStyle: .none, timeStyle: .short)
    }
    
    func runCounter(counter: Binding<Double>, start: Double, end: Double, speed: Double) {
        counter.wrappedValue = start

        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            counter.wrappedValue += 1.0
            if counter.wrappedValue == end {
                timer.invalidate()
            }
        }
    }
    
    func getDeliveryService() -> [DeliveryService] {
        var temporaryServices: [DeliveryService] = []
        DeliveryService.allCases.forEach {
            temporaryServices.append($0)
        }
        return temporaryServices
    }
}

