//
//  Person.swift
//  Search
//
//  Created by Marcos Salas on 6/2/25.
//

import SwiftData

@Model
final class Person {
    var name: String
    var lastname: String
    var address: Address
    
    init(name: String, lastname: String, address: Address) {
        self.name = name
        self.lastname = lastname
        self.address = address
    }
}

struct Address: Codable {
    var street: String
    var zipCode: Int
}
