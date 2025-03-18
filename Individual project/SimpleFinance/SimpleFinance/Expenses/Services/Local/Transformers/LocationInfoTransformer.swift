//
//  LocationInfoTransformer.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 24/2/25.
//

import Foundation

@objc(LocationInfoTransformer)
class LocationInfoTransformer: ValueTransformer {
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let location = value as? LocationInfo else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: true)
            return data
        } catch {
            print("Error encoding LocationInfo: \(error)")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            let location = try NSKeyedUnarchiver.unarchivedObject(ofClass: LocationInfo.self, from: data as Data)
            return location
        } catch {
            print("Error decoding LocationInfo: \(error)")
            return nil
        }
    }
}
