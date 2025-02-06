//
//  ContentView.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Item.note, order: .forward) private var items: [Item]

  @State private var showSheet = false
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          NavigationLink {
            TaskDetailView(item: item)
          } label: {
            HStack {
              Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .onTapGesture {
                  item.isCompleted.toggle()
                  //try? modelContext.save()
                }
              if item.isCompleted {
                Text(item.note)
                  .strikethrough()
              } else {
                Text(item.note)
              }
            }
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button {
            showSheet.toggle()
          } label: {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      .sheet(isPresented: $showSheet) {
        TaskFormView()
          .presentationDetents([.medium])
          .presentationDragIndicator(.visible)
      }
    } detail: {
      Text("Select an item")
    }
    .onAppear {
      //modelContext.autosaveEnabled = false
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
}

#Preview {
  TaskListView()
    .modelContainer(for: Item.self, inMemory: true)
}
