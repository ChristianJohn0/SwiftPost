//
//  DeliveryProgressView.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import SwiftUI

struct DeliveryProgressView: View {
    private let state: DeliveryState
    
    @State private var preTransitCounter = 0.0
    @State private var inTransitCounter = 0.0
    @State private var outForDeliverCounter = 0.0
    @State private var deliveredCounter = 0.0
    
    init(using state: DeliveryState) {
        self.state = state
    }
        
    var body: some View {
        if #available(iOS 14.0, *) {
            switch state {
            case .preTransit:
                ProgressView(value: preTransitCounter, total: 100.0)
                    .onAppear {
                        Miscellaneous().runCounter(counter: self.$preTransitCounter, start: 0.0, end: 25.0, speed: 0.05)
                    }
            case .inTransit:
                ProgressView(value: inTransitCounter, total: 100.0)
                    .onAppear {
                        Miscellaneous().runCounter(counter: self.$inTransitCounter, start: 0.0, end: 50.0, speed: 0.05)
                    }
            case .outForDelivery:
                ProgressView(value: outForDeliverCounter, total: 100.0)
                    .onAppear {
                        Miscellaneous().runCounter(counter: self.$outForDeliverCounter, start: 0.0, end: 75.0, speed: 0.05)
                    }
            case .delivered:
                ProgressView(value: deliveredCounter, total: 100.0)
                    .onAppear {
                        Miscellaneous().runCounter(counter: self.$deliveredCounter, start: 0.0, end: 100.0, speed: 0.05)
                    }
            }
        }
    }
}

