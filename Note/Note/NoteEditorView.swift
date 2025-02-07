//
//  NoteEditorView.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 7/2/25.
//

import SwiftUI
import CloudKit
import PhotosUI
import Observation

struct NoteEditorView: View {
  enum Mode: Equatable {
    case create
    case edit(Note)
  }

  let mode: Mode
  @Environment(\.dismiss) private var dismiss
  @Environment(CloudKitManager.self) private var cloudKit

  @Bindable private var viewModel: NoteEditorViewModel
  @State private var selectedItem: PhotosPickerItem?

  init(mode: Mode) {
    self.mode = mode
    self.viewModel = NoteEditorViewModel(mode: mode)
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $viewModel.title)
        TextField("Description", text: $viewModel.description, axis: .vertical)

        PhotosPicker(selection: $selectedItem, matching: .images) {
          if let imageData = viewModel.imageData,
             let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFit()
              .frame(height: 200)
          } else {
            Text("Select Image")
          }
        }
      }
      .navigationTitle(mode == .create ? "New Note" : "Edit Note")
      .toolbar {
        Button("Save") {
          save()
        }
        .disabled(viewModel.title.isEmpty)
      }
      .onChange(of: selectedItem) {
        Task {
          if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
            viewModel.imageData = data
          }
        }
      }
    }
  }

  private func save() {
    Task {
      do {
        switch mode {
        case .create:
          let note = try await cloudKit.save(
            title: viewModel.title,
            description: viewModel.description,
            imageData: viewModel.imageData
          )
          cloudKit.notes.append(note)
        case .edit(let note):
          let updatedNote = Note(
            id: note.id,
            title: viewModel.title,
            description: viewModel.description,
            imageData: viewModel.imageData
          )
          try await cloudKit.update(updatedNote)
          if let index = cloudKit.notes.firstIndex(where: { $0.id == note.id }) {
            cloudKit.notes[index] = updatedNote
          }
        }
        dismiss()
      } catch {
        print("Error saving note: \(error)")
      }
    }
  }
}
