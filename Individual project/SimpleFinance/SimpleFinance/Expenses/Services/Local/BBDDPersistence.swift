//
//  BBDDPersistence.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 24/2/25.
//

import CoreData

struct PersistenceManager {
  static let shared = PersistenceManager()
    let container: NSPersistentContainer
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "SimpleFinance")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }

      guard let description = container.persistentStoreDescriptions.first else {
          fatalError("App creating persistencestore")
      }
    
      description.type = NSSQLiteStoreType
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      
    container.loadPersistentStores { storeDescription, error in
        if error != nil {
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
      let newExpense = Expense(context: viewContext)
        newExpense.id = UUID()
        newExpense.title = "Expense \(i)"
        newExpense.amount = Double(Double.random(in: 0..<100))
        newExpense.date = Date.now
        newExpense.type = ExpenseType.allCases.randomElement()!.rawValue
        
        let location = LocationInfo(latitude: 40.7128, longitude: -74.0060, name: "New York")
        let locationData = LocationInfoTransformer().transformedValue(location) as? LocationInfo
        newExpense.locationInfo = locationData
        
        let attachment = AttachmentInfo(id: UUID(), fileName: "document\(i).pdf", contentType: "application/pdf")
        let attachmentData = AttachmentInfoTransformer().transformedValue(attachment) as? AttachmentInfo
        newExpense.attachmentInfo = attachmentData
    }

    do {
      try viewContext.save()
    } catch {
      print("Error insertando")
    }

    return result
  }()

}



