//
//  BookListSwiftUIApp.swift
//  BookListSwiftUI
//
//  Created by Libranner Leonel Santos Espinal on 27/1/22.
//

import SwiftUI

@main
struct BookListSwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      BooksListView()
    }
    .environment(\.managedObjectContext, PersistenceManager.shared.container.viewContext)
  }
}
