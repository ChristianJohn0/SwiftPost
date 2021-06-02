//
//  Extensions.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import Foundation
import SwiftUI

extension Color {
    static let applicationColor = Color(red: 0.05, green: 0.066, blue: 0.091)
    static let applicationGradientColorOne = Color(red: 0.05, green: 0.066, blue: 0.091)
    static let applicationGradientColorTwo = Color(red: 0.086, green: 0.105, blue: 0.134)
}

extension String {
    static let trackOrderURL = "https://swift-post-api.azurewebsites.net/dev/v1/track?tracking_code=MW517419064CA&carrier=CanadaPost"
    static func generateTrackingURL(using code: String, delivery service: DeliveryService) -> String {
        return "https://swift-post-api.azurewebsites.net/dev/v1/track?tracking_code=" + code + "&carrier=" + String(describing: service)
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension DateFormatter {
    static var mediumDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    static var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    static var shortTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
}
