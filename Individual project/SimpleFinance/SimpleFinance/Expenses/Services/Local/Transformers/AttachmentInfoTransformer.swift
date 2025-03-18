//
//  AttachmentInfoTransformer.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 24/2/25.
//

import Foundation

@objc(AttachmentInfoTransformer)
class AttachmentInfoTransformer: ValueTransformer {
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let attachment = value as? AttachmentInfo else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: attachment, requiringSecureCoding: true)
            return data
        } catch {
            print("Error encoding AttachmentInfo: \(error)")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            // Usamos NSKeyedUnarchiver para decodificar Data a AttachmentInfo
            let attachment = try NSKeyedUnarchiver.unarchivedObject(ofClass: AttachmentInfo.self, from: data as Data)
            return attachment
        } catch {
            print("Error decoding AttachmentInfo: \(error)")
            return nil
        }
    }
}
