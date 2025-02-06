//
//  TaskerApp.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftUI
import SwiftData

@main
struct TaskerApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
      User.self
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
      TabView {
        TaskListView()
          .tabItem {
            Label("Tasks", systemImage: "checklist.checked")
          }
        UserListView()
          .tabItem {
            Label("Users", systemImage: "person.2.circle.fill")
          }
      }
    }
    .modelContainer(sharedModelContainer)
  }
}
