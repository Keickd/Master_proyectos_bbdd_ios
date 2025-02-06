//
//  ContentView.swift
//  Search
//
//  Created by Marcos Salas on 6/2/25.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var people: [Person]
    
    init(criteria: String, sort: [SortDescriptor<Person>], age: Int) {
        let predicate = #Predicate<Person> { person in
            
            criteria.isEmpty ||
            person.name.localizedStandardContains(criteria) ||
            person.lastname.localizedStandardContains(criteria) ||
            person.age > age
        }
        
        _people = Query(filter: predicate, sort: sort)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(people) { person in
                    VStack(alignment: .leading) {
                        Text("\(person.name) \(person.lastname)")
                            .font(.headline)
                        Text("\(person.address.street) \(person.address.zipCode)")
                            .font(.subheadline)
                        Text("\(person.age)")
                            .font(.footnote)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State var criteria: String = ""
    @State var ascendingSort = true
    
    @Environment(\.modelContext) private var modelContext
    
    var age: Int {
        Int(criteria) ?? 0
    }
    
    var body: some View {
        NavigationStack {
            PeopleView(criteria: criteria, sort: sortDescriptors, age: age)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            ascendingSort.toggle()
                        } label: {
                            Label("Sort", systemImage: ascendingSort ? "arrow.up" : "arrow.down")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            load()
                        } label: {
                            Label("Load", systemImage: "arrow.trianglehead.clockwise")
                        }
                    }
                }
        }
        .searchable(text: $criteria)

    }
    
    var sortDescriptors: [SortDescriptor<Person>] {
        [SortDescriptor(\Person.name, order: ascendingSort ? .forward : .reverse)]
    }
    
    private func load() {
        let people: [Person] = [
            .init(name: "Michael", lastname: "Scoot", address: .init(street: "42 Dunkie Way", zipCode: 12345), age: 56),
            .init(name: "John", lastname: "Williams", address: .init(street: "34 Faraday Street", zipCode: 456789), age: 28)
        ]
        
        people.forEach { person in
            modelContext.insert(person)
        }
        do{
            try modelContext.save()
        }catch {
            fatalError("")
        }
    }
}

/*
#Preview {
    PeopleView(modelContext: , people: [
        Person(name: "Michael", lastname: "Scoot", address: .init(street: "42 Dunkie Way", zipCode: 12345)),
        Person(name: "John", lastname: "Williams", address: .init(street: "34 Faraday Street", zipCode: 456789))
    ])
}
*/
