import Foundation
import CoreData

@Observable
final class LocalPersistenceService {
    static let shared = LocalPersistenceService()

    let context: NSManagedObjectContext

    private init() {
        context = PersistenceManager.shared.container.viewContext
    }

    private(set) var expenses: [Expense] = []

    func load() {
        expenses = getAll()
    }

    func getAll() -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error al obtener los gastos: \(error.localizedDescription)")
            return []
        }
    }

    func add(_ expense: Expense) {
        saveContext()
        load()
    }

    func update(_ expense: Expense) {
        saveContext()

        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = context.object(with: expense.objectID) as! Expense
        }
        load()
    }

    func delete(_ expense: Expense) {
        context.delete(expense)
        saveContext()
        load()
    }

    func delete(_ ids: [UUID]) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
            load()
        } catch {
            print("Error al eliminar los gastos: \(error.localizedDescription)")
        }
    }

    private func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error al guardar cambios en Core Data: \(error.localizedDescription)")
        }
    }
}
