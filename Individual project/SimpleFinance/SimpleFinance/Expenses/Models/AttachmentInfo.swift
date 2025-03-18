//
//  AttachmentInfo.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 19/2/25.
//

import Foundation

public class AttachmentInfo: NSObject, Codable, Identifiable, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public let id: UUID
    let fileName: String
    let contentType: String

    init(id: UUID, fileName: String, contentType: String) {
        self.id = id
        self.fileName = fileName
        self.contentType = contentType
    }

    // Requerido por NSSecureCoding
    public required init?(coder aDecoder: NSCoder) {
        // Decodificando el UUID como String
        guard let idString = aDecoder.decodeObject(of: NSString.self, forKey: "id") as String?,
              let id = UUID(uuidString: idString),
              let fileName = aDecoder.decodeObject(of: NSString.self, forKey: "fileName") as String?,
              let contentType = aDecoder.decodeObject(of: NSString.self, forKey: "contentType") as String? else {
                  return nil
              }
        self.id = id
        self.fileName = fileName
        self.contentType = contentType
    }

    // Requerido por NSSecureCoding
    public func encode(with aCoder: NSCoder) {
        // Codificando el UUID como String
        aCoder.encode(id.uuidString, forKey: "id")
        aCoder.encode(fileName, forKey: "fileName")
        aCoder.encode(contentType, forKey: "contentType")
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
