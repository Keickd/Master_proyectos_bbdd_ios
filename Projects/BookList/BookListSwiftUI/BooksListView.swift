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
    @State private var sections: [(id: Int16, books: [Book])] = []

  var body: some View {
      NavigationStack {
        VStack {
            BookFormView{
                fetchBooks()
            }
            .padding()
          List {
            ForEach(sections, id: \.id) { section in
              Section(header: RatingView(rating: .constant(Int(section.id)))) {
                ForEach(section.books) { book in
                    Text(book.name!)
                }
                .onDelete { offsets in
                  deleteBooks(offsets: offsets, sectionId: section.id)
                  fetchBooks()
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
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }
      .onAppear(perform: fetchBooks)
      .onChange(of: viewContext.hasChanges) {
        fetchBooks()
      }
      .navigationBarTitle("My Books")
    }
    .navigationViewStyle(.stack)
  }

    private func fetchBooks() {
      let request = Book.fetchRequest()
      request.sortDescriptors = [
        NSSortDescriptor(keyPath: \Book.rating, ascending: false),
        NSSortDescriptor(keyPath: \Book.name, ascending: true)
      ]

      do {
        let books = try viewContext.fetch(request)

        let groupedBooks = Dictionary(grouping: books) { $0.rating }

        sections = groupedBooks.map { (id: $0.key, books: $0.value) }
          .sorted { $0.id > $1.id }


      } catch {
        print("Error fetching books: \(error)")
      }
    }

    private func deleteBooks(offsets: IndexSet, sectionId: Int16) {
      if let sectionIndex = sections.firstIndex(where: { $0.id == sectionId }) {
        offsets.map { sections[sectionIndex].books[$0] }
          .forEach(viewContext.delete)
        do {
          try viewContext.save()
        } catch {
          print("Error deleting books: \(error)")
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView()
          .environment(\.managedObjectContext, PersistenceManager.preview.container.viewContext)
  }
}
