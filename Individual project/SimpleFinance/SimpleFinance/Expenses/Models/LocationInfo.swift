//
//  LocationInfo.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 19/2/25.
//

import Foundation

public class LocationInfo: NSObject, Codable, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool {
        return true
    }

    let latitude: Double
    let longitude: Double
    let name: String?

    init(latitude: Double, longitude: Double, name: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }

    public required init?(coder aDecoder: NSCoder) {
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
        self.name = aDecoder.decodeObject(of: NSString.self, forKey: "name") as String?
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(name, forKey: "name")
    }
}
