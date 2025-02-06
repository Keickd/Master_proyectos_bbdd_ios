//
//  UserListView.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftData
import SwiftUI

struct UserListView: View {
  @Query(sort: \User.name, order: .forward) private var users: [User]
  @State private var userName = ""
  @State private var showAlert = false
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    NavigationStack {
      List {
        ForEach(users) { user in
            NavigationLink {
                UserDetailView(user: user)
            } label: {
                VStack(alignment: .leading){
                    Text(user.name)
                    Text("\(user.items?.count ?? 0) Tasks")
                        .font(.caption)
                }
            }
        }
        .onDelete(perform: deleteItems)
      }
      .alert("New User", isPresented: $showAlert) {
        TextField("Enter user's name", text: $userName)
        Button("OK") {
          if !userName.isEmpty {
              let user = User(name: userName)
              modelContext.insert(user)
              try! modelContext.save()
          }
        }
        Button("Cancel", role: .cancel) { }
      }
      .toolbar {
        ToolbarItem {
          Button {
            userName = ""
            showAlert.toggle()
          } label: {
            Label("Add User", systemImage: "plus")
          }
        }
      }
    }
  }

  private func deleteItems(offsets: IndexSet) {
      withAnimation {
            for index in offsets {
                modelContext.delete(users[index])
          }
      }
  }
}

#Preview {
    UserListView()
        .modelContainer(for: User.self, inMemory: true)
}
