//
//  LocationInfoTransformer.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 24/2/25.
//

import Foundation

@objc(LocationInfoTransformer)
class LocationInfoTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let location = value as? LocationInfo else { return nil }
        do {
            return try JSONEncoder().encode(location)
        } catch {
            print("Error encoding LocationInfo: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try JSONDecoder().decode(LocationInfo.self, from: data)
        } catch {
            print("Error decoding LocationInfo: \(error)")
            return nil
        }
    }
}
