//
//  TaskForm.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftData
import SwiftUI

struct TaskFormView: View {
  @State private var note = ""
  @State private var level = Level.easy
  @State private var assignedTo: User?

  @Query(sort: \User.name) private var users: [User]

  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    VStack(spacing: 30.0) {
      TextField("Note", text: $note)
        .font(.title)
        .textFieldStyle(.roundedBorder)

      Picker("Level", selection: $level) {
        ForEach(Level.allCases, id: \.self) { lang in
          Text(lang.rawValue)
        }
      }
      .pickerStyle(.segmented)


      if !users.isEmpty {
        Picker("User", selection: $assignedTo) {
          ForEach(users, id: \.self) { user in
            Text(user.name)
              .tag(user as User?)
          }
        }
        .pickerStyle(.wheel)
      } else {
        Text("You need to create users")
          .foregroundStyle(.red)
      }

      Button {
        if let assignedTo {
            let newItem = Item(note: note, level: level, assignedTo: assignedTo)
            modelContext.insert(newItem)
            try! modelContext.save()
          dismiss()
        }
      } label: {
        Label("Add Item", systemImage: "plus")
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .tint(.primary)
    }
    .padding()
    .onAppear {
      assignedTo = users.first
    }
  }
}
#Preview {
  TaskFormView()
}
