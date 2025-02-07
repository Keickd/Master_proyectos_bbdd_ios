//
//  NoteRowView.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 7/2/25.
//
import SwiftUI

struct NoteRowView: View {
  let note: Note

  var body: some View {
    VStack(alignment: .leading) {
      Text(note.title)
        .font(.headline)
      Text(note.description)
        .font(.subheadline)
        .lineLimit(2)
      if let imageData = note.imageData,
         let uiImage = UIImage(data: imageData) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
          .frame(height: 100)
      }
    }
  }
}
