//
//  SimpleListView.swift
//  BookListSwiftUI
//
//  Created by Libranner Leonel Santos Espinal on 29/1/24.
//

import SwiftUI

struct SimpleListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.name, ascending: true)], animation: .default
    )
    
    private var books: FetchedResults<Book>

  var body: some View {
    NavigationView {
      VStack {
        BookFormView()
          .padding()

        List {
          ForEach(books) { book in
            Text(book.name!)
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }
      .navigationBarTitle("My Books")
    }
    .navigationViewStyle(.stack)
  }
}

#Preview {
    SimpleListView()    .environment(\.managedObjectContext, PersistenceManager.preview.container.viewContext)

}
