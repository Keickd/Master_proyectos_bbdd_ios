//
//  UserDetailView.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftUI

struct UserDetailView: View {
  let user: User
  var body: some View {
    if let items = user.items {
      List {
        ForEach(items) { item in
          if item.isCompleted {
            Text(item.note)
              .strikethrough()
          } else {
            Text(item.note)
          }
        }
      }
      .navigationTitle(Text(user.name))
    }
  }
}

#Preview {
  UserDetailView(user: .init(name: "Test User"))
}
