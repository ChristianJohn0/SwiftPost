//
//  SwiftPostApp.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import SwiftUI

@main
struct SwiftPostApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            HomeView().environment(\.managedObjectContext, persistenceController.container.viewContext)
//            TestingView()
        }
    }
}
