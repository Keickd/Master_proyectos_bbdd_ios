//
//  SearchApp.swift
//  Search
//
//  Created by Marcos Salas on 6/2/25.
//

import SwiftUI
import SwiftData

@main
struct SearchApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Person.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
