//
//  TaskDetailView.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftUI

struct TaskDetailView: View {
  let item: Item
  
  var body: some View {
    VStack(alignment: .leading) {
      Label(
        title: { Text("Note") },
        icon: { Image(systemName: "pencil.circle") }
      )
      .font(.headline)
      
      Text(item.note)
        .font(.title)
        .padding(.bottom)
      
      Label(
        title: { Text("Level") },
        icon: { Image(systemName: "figure.strengthtraining.traditional") }
      )
      .font(.headline)
      Text(item.level.rawValue)
        .font(.title2)
    }
    .padding()
  }
}

#Preview {
  TaskDetailView(item: .init(note: "This is a note. This is a note", level: .hard, assignedTo: .init(name: "Test User")))
}
