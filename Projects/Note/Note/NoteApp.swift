//
//  NoteApp.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 25/12/24.
//

import SwiftUI

// MARK: - App Entry
@main
struct NotesApp: App {
  private var cloudKitManager = CloudKitManager()

  var body: some Scene {
    WindowGroup {
      NoteListView()
        .environment(cloudKitManager)
    }
  }
}
