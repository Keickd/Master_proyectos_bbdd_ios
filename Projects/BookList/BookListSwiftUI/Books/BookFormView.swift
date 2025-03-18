//
//  BookFormView.swift
//  BookListSwiftUI
//
//  Created by Libranner Leonel Santos Espinal on 30/1/24.
//

import SwiftUI
import CoreData

struct BookFormView: View {
  @State private var bookName: String = ""
  @State private var rating = 0
    @Environment(\.managedObjectContext) private var viewContext
    let onSave: () -> Void

  var body: some View {
    HStack {
      VStack(spacing: 15.0) {
        TextField("Name: ", text: $bookName, prompt: Text("insert book name"))
          .textFieldStyle(.roundedBorder)
        RatingView(rating: $rating)
          .font(.title)
      }
      Button(action: addBook) {
        Image(systemName: "plus")
      }
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.circle)
      .controlSize(.extraLarge)
    }
  }

  private func addBook() {
    guard !bookName.isEmpty else {
      return
    }

    withAnimation {
        if let newBook = NSEntityDescription.insertNewObject(forEntityName: "Book", into: viewContext) as? Book {
            newBook.name = bookName
            newBook.rating = Int16(rating)
        }
        do{
            try viewContext.save()
            onSave()
        } catch {
            print("")
        }

      bookName = ""
      rating = 0
    }
  }
}

#Preview {
    BookFormView{}
}
