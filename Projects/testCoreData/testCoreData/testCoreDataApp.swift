//
//  testCoreDataApp.swift
//  testCoreData
//
//  Created by Marcos Salas on 19/2/25.
//

import SwiftUI

@main
struct testCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
