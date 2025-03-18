//
//  LocationInfo.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 19/2/25.
//

import Foundation

public class LocationInfo: NSObject, Codable {
    let latitude: Double
    let longitude: Double
    let name: String?

    init(latitude: Double, longitude: Double, name: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
