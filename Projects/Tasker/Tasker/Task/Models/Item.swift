//
//  Item.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import Foundation
import SwiftData


enum Level: String, CaseIterable, Codable {
  case easy
  case medium
  case hard
}

@Model
final class Item {
  var note: String
  var level: Level
  var assignedTo: User
  var isCompleted = false

  init(note: String, level: Level, assignedTo: User) {
    self.note = note
    self.level = level
    self.assignedTo = assignedTo
  }
}
