//
//  CoasterCollectorApp.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import SwiftUI

@main
struct CoasterCollectorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
