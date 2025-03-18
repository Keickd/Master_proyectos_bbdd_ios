//
//  AttachmentInfo.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 19/2/25.
//

import Foundation

public class AttachmentInfo: NSObject, Codable, Identifiable {
    public let id: UUID
    let fileName: String
    let contentType: String

    init(id: UUID, fileName: String, contentType: String) {
        self.id = id
        self.fileName = fileName
        self.contentType = contentType
    }

    var fileURL: URL {
        FileManager.default.documentsDirectory
            .appendingPathComponent(fileName)
    }
}

extension FileManager {
    var documentsDirectory: URL {
        self.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

