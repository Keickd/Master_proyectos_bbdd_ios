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
    var locationInfo: LocationInfo?
    var attachmentInfo: AttachmentInfo?

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
        
        if let locationInfo = expense?.locationInfo as? LocationInfo {
            self.locationInfo = locationInfo
        } else {
            self.locationInfo = nil
        }

        if let attachmentInfo = expense?.attachmentInfo as? AttachmentInfo {
            self.attachmentInfo = attachmentInfo
        } else {
            self.attachmentInfo = nil
        }
    }
    
    func saveExpense() {
        if isNewExpense {
            let newExpense = Expense(context: persistentService.context)
            newExpense.id = id
            newExpense.title = title
            newExpense.amount = amount
            newExpense.date = date
            newExpense.type = type.rawValue
            newExpense.attachmentInfo = attachmentInfo
            newExpense.locationInfo = locationInfo
            persistentService.add(newExpense)
        } else {
            expense?.title = title
            expense?.amount = amount
            expense?.date = date
            expense?.type = type.rawValue
            expense?.attachmentInfo = attachmentInfo
            expense?.locationInfo = locationInfo
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
            
            if let encodedData = AttachmentInfoTransformer().transformedValue(attachmentInfo) as? NSData {
                expense?.attachmentInfo = encodedData
            } else {
                print("Error: No se pudo transformar AttachmentInfo a NSData")
                expense?.attachmentInfo = nil
            }
        } catch {
            // En caso de error, vaciar el attachmentInfo y mostrar el error
            expense?.attachmentInfo = nil
            print("Error saving attachment: \(error)")
        }
    }

    func deleteAttachment() {
        tempAttachmentData = nil
        attachmentInfo = nil
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

        self.attachmentInfo = attachmentInfo
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

            self.attachmentInfo = attachmentInfo
        } catch {
            print("Error preparando PDF: \(error)")
        }
    }

    func saveLocation(name: String, coordinate: CLLocationCoordinate2D) {
        let updatedLocation = LocationInfo(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            name: name
        )
        
        if let encodedData = LocationInfoTransformer().transformedValue(updatedLocation) as? Data {
            expense?.locationInfo = encodedData as NSData
        } else {
            print("Error: No se pudo codificar la ubicación")
        }
    }

    
    func cleanLocation() {
        expense?.locationInfo = nil
    }
}
