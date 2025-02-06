//
//  Person.swift
//  Search
//
//  Created by Marcos Salas on 6/2/25.
//

import SwiftData

@Model
final class Person {
    #Unique<Person>([\.name, \.lastname])
    
    var name: String
    var lastname: String
    var address: Address
    var age: Int
    
    init(name: String, lastname: String, address: Address, age: Int) {
        self.name = name
        self.lastname = lastname
        self.address = address
        self.age = age
    }
}

struct Address: Codable {
    var street: String
    var zipCode: Int
}
