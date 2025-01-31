//
//  RatingView.swift
//  BookListSwiftUI
//
//  Created by Libranner Leonel Santos Espinal on 29/1/24.
//

import SwiftUI

struct RatingView: View {
  @Binding var rating: Int

  var body: some View {
    HStack {
      ForEach(1..<6) { value in
        Image(systemName: value <= rating ? "star.fill" : "star")
          .foregroundStyle(.primary)
          .onTapGesture {
            rating = value
          }
      }
    }
  }
}

#Preview {
  RatingView(rating: .constant(3))
}
