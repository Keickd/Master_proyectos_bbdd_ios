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
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", expense.id! as any CVarArg as CVarArg)

        do {
            if let existingExpense = try context.fetch(request).first {
                existingExpense.title = expense.title
                existingExpense.amount = expense.amount
                existingExpense.date = expense.date
                existingExpense.type = expense.type
                existingExpense.locationInfo = expense.locationInfo
                existingExpense.attachmentInfo = expense.attachmentInfo
                saveContext()
                load()
            }
        } catch {
            print("Error al actualizar el gasto: \(error.localizedDescription)")
        }
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
