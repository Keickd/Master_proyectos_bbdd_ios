//
//  Note.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 7/2/25.
//

import CloudKit

struct Note: Identifiable, Equatable {
  let id: CKRecord.ID?
  var title: String
  var description: String
  var imageData: Data?

  init(id: CKRecord.ID? = nil, title: String, description: String, imageData: Data? = nil) {
    self.id = id
    self.title = title
    self.description = description
    self.imageData = imageData
  }

  init?(record: CKRecord) {
    self.id = record.recordID
    self.title = record["title"] as? String ?? ""
    self.description = record["description"] as? String ?? ""
    if let asset = record["image"] as? CKAsset, let data = try? Data(contentsOf: asset.fileURL!) {
      self.imageData = data
    }
  }
}
