//
//  NoteListView.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 7/2/25.
//

import SwiftUI

struct NoteListView: View {
  @Environment(CloudKitManager.self) private var cloudKit
  @State private var showingAddNote = false
  @State private var selectedNote: Note?

  var body: some View {
    NavigationStack {
      List {
        ForEach(cloudKit.notes) { note in
          NoteRowView(note: note)
            .onTapGesture {
              selectedNote = note
            }
        }
        .onDelete { indexSet in
          deleteNotes(at: indexSet)
        }
      }
      .navigationTitle("Notes")
      .toolbar {
        Button(action: { showingAddNote.toggle() }) {
          Image(systemName: "plus")
        }
      }
      .sheet(isPresented: $showingAddNote) {
        NoteEditorView(mode: .create)
      }
      .sheet(item: $selectedNote) { note in
        NoteEditorView(mode: .edit(note))
      }
      .task {
        do {
          try await cloudKit.fetch()
        } catch {
          print("Error fetching notes: \(error)")
        }
      }
    }
  }

  private func deleteNotes(at offsets: IndexSet) {
    Task {
      do {
        for index in offsets {
          try await cloudKit.delete(cloudKit.notes[index])
        }
      } catch {
        print("Error deleting notes: \(error)")
      }
    }
  }
}
