import SwiftUI
import CoreData
import CoreLocation
import Observation

@Observable
class ExpenseViewModel {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var type: ExpenseType

    var expense: Expense?

    let isNewExpense: Bool
    private(set) var tempAttachmentData: (data: Data, fileName: String, contentType: String)?
    private let persistentService: LocalPersistenceService

    init(isNewExpense: Bool, expense: Expense?, persistentService: LocalPersistenceService) {
        self.isNewExpense = isNewExpense
        self.persistentService = persistentService
        self.expense = expense

        self.id = expense?.id ?? UUID()
        self.title = expense?.title ?? ""
        self.amount = expense?.amount ?? 0.0
        self.date = expense?.date ?? Date()
        self.type = ExpenseType(rawValue: expense?.type ?? "") ?? .other
    }
    
    func saveExpense() {
        if isNewExpense {
            let newExpense = Expense(context: persistentService.context)
            newExpense.id = id
            newExpense.title = title
            newExpense.amount = amount
            newExpense.date = date
            newExpense.type = type.rawValue
            persistentService.add(newExpense)
        } else {
            expense?.title = title
            expense?.amount = amount
            expense?.date = date
            expense?.type = type.rawValue
            persistentService.update(expense!)
        }
    }
        
    func saveAttachment() {
        guard let (data, fileName, _) = tempAttachmentData else { return }
        
        let fileURL = FileManager.default.documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            
            let attachmentInfo = AttachmentInfo(
                id: UUID(),
                fileName: fileName,
                contentType: "image/jpeg"
            )
            
            expense?.attachmentInfo = attachmentInfo
        } catch {
            expense?.attachmentInfo = nil
            print("Error saving attachment: \(error)")
        }
    }
    
    func deleteAttachment() {
        guard let attachmentData = expense?.attachmentInfo,
              let attachmentInfo = try? JSONDecoder().decode(AttachmentInfo.self, from: attachmentData as! Data) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: attachmentInfo.fileURL)
        } catch {
            print("Error deleting attachment: \(error)")
        }

        tempAttachmentData = nil
        expense?.attachmentInfo = nil
    }

    func handleImageSelection(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        tempAttachmentData = (imageData, fileName, "image/jpeg")

        let attachmentInfo = AttachmentInfo(
            id: UUID(),
            fileName: fileName,
            contentType: "image/jpeg"
        )

        expense?.attachmentInfo = attachmentInfo
    }

    func handleDocumentSelection(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result,
              let url = urls.first,
              url.startAccessingSecurityScopedResource() else {
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            tempAttachmentData = (data, fileName, "application/pdf")

            let attachmentInfo = AttachmentInfo(
                id: UUID(),
                fileName: fileName,
                contentType: "application/pdf"
            )

            expense?.attachmentInfo = attachmentInfo
        } catch {
            print("Error preparando PDF: \(error)")
        }
    }

    // MARK: - Guardar y Limpiar Localización
    
    func saveLocation(name: String, coordinate: CLLocationCoordinate2D) {

        let updatedLocation = LocationInfo(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            name: name
        )
        
        expense?.locationInfo = updatedLocation
    }
    
    func cleanLocation() {
        expense?.locationInfo = nil
    }
}
