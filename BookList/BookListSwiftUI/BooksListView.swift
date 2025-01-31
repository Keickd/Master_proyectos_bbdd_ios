//
//  ContentView.swift
//  BookListSwiftUI
//
//  Created by Libranner Leonel Santos Espinal on 27/1/22.
//

import SwiftUI
import CoreData

struct BooksListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @SectionedFetchRequest(
        sectionIdentifier: \Book.rating,
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.rating, ascending: false),
       NSSortDescriptor(keyPath: \Book.name, ascending: true)], animation: .default
    )
    
    private var books: SectionedFetchResults<Int16, Book>

  var body: some View {
    NavigationView {
      VStack {
        BookFormView()
        .padding()
        List {
          ForEach(books) { section in
            Section(header: RatingView(rating: .constant(Int(section.id)))) {
              ForEach(section) { book in
                Text(book.name!)
              }
              .onDelete {
                  deleteBooks(offsets: $0, sectionId: section.id)
              }
            }
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

  private func deleteBooks(offsets: IndexSet, sectionId: Int16) {
      if let section = books.first(where: { $0.id == sectionId }) {
          offsets.map { section[$0] }
              .forEach(viewContext.delete)
      }
      
      do{
          try viewContext.save()
      } catch {
          print("")
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView()
          .environment(\.managedObjectContext, PersistenceManager.preview.container.viewContext)
  }
}

