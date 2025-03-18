//
//  AttachmentInfoTransformer.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 24/2/25.
//

import Foundation

@objc(AttachmentInfoTransformer)
class AttachmentInfoTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let attachment = value as? AttachmentInfo else { return nil }
        do {
            return try JSONEncoder().encode(attachment)
        } catch {
            print("Error encoding AttachmentInfo: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try JSONDecoder().decode(AttachmentInfo.self, from: data)
        } catch {
            print("Error decoding AttachmentInfo: \(error)")
            return nil
        }
    }
}
