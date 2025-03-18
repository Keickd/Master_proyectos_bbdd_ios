//
//  Persistence.swift
//  BookListSwiftUI
//
//  Created by Libranner Leonel Santos Espinal on 27/1/22.
//

import CoreData

struct PersistenceManager {
  static let shared = PersistenceManager()
    let container: NSPersistentContainer
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "BookListSwiftUI")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }

      guard let description = container.persistentStoreDescriptions.first else {
          fatalError("App creating persistencestore")
      }
    //
      description.type = NSSQLiteStoreType
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      
    container.loadPersistentStores { storeDescription, error in
      if let error {
        fatalError("App crashes when trying to configure Core Data")
      }
    }
      
      spotlightDelegate = NSCoreDataCoreSpotlightDelegate(forStoreWith: description, coordinator: container.persistentStoreCoordinator)
      spotlightDelegate.startSpotlightIndexing()
  }
    

  static var preview: PersistenceManager = {
    let result = PersistenceManager(inMemory: true)
    let viewContext = result.container.viewContext

    for i in 0..<10 {
      let newBook = Book(context: viewContext)
      newBook.name = "Book \(i)"
        newBook.rating = Int16(Int.random(in: 0..<6))
    }

    do {
      try viewContext.save()
    } catch {
      print("Error insertando")
    }

    return result
  }()

}



