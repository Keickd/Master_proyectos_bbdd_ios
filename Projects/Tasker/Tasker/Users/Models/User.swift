//
//  User.swift
//  Tasker
//
//  Created by Libranner Leonel Santos Espinal on 27/1/24.
//

import SwiftData

@Model
final class User {
  @Attribute(.unique) var name: String
  @Relationship(deleteRule: .cascade, inverse: \Item.assignedTo)
  var items: [Item]?

  init(name: String) {
    self.name = name
  }
}
