//
//  NoteEditorViewModel.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 7/2/25.
//

import Observation
import Foundation

@Observable
class NoteEditorViewModel {
  var title: String = ""
  var description: String = ""
  var imageData: Data?

  init(mode: NoteEditorView.Mode) {
    if case .edit(let note) = mode {
      self.title = note.title
      self.description = note.description
      self.imageData = note.imageData
    }
  }
}
