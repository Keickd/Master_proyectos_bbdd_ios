//
//  ExpenseFormView.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI
import MapKit
import CoreData

struct EditExpenseFormView: View {
    var viewModel: ExpenseViewModel

    init(
        expense: Expense
    ) {
        self.viewModel =  ExpenseViewModel(
            isNewExpense: false,
            expense: expense,
            persistentService: LocalPersistenceService.shared
        )
    }

    var body: some View {
        ExpenseFormView(
            viewModel: viewModel
        )
    }
}

struct NewExpenseFormView: View {
    
    var viewModel = ExpenseViewModel(
        isNewExpense: true,
        expense: nil,
        persistentService: LocalPersistenceService.shared
    )
    
    var body: some View {
        ExpenseFormView(
            viewModel: viewModel
        )
    }
}

struct ExpenseFormView: View {
    @Environment(
        \.dismiss
    ) private var dismiss
    @State private var showingAttachmentSheet = false
    @State private var showingImagePicker = false
    @State private var showingDocumentPicker = false
    @State private var showingCamera = false
    @State private var showingAttachmentPreview = false
    @State private var showingLocationPicker = false
    @State private var showingSaveDialog = false
    @State private var showErrorAlert = false
    @State private var locationName: String = ""
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    
    @Bindable var viewModel: ExpenseViewModel
    
    @State private var position: MapCameraPosition = .userLocation(
        fallback: .automatic
    )
    
    @State private var customError = CustomError(title: "Generic error", message: "")
    
    var body: some View {
        
        let _ = Self._printChanges()
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Enter Amount",
                        value: $viewModel.amount,
                        format: .number
                    )
                    .keyboardType(
                        .decimalPad
                    )
                    .font(
                        .system(
                            size: 50
                        )
                    )
                } header: {
                    HStack {
                        Image(
                            systemName: "dollarsign"
                        )
                        Text(
                            "Amount"
                        )
                    }
                }
                
                Section {
                    TextField(
                        "Enter Title",
                        text: $viewModel.title
                    )
                    Picker(
                        "Type",
                        selection: $viewModel.type
                    ) {
                        ForEach(
                            ExpenseType.allCases
                        ) { type in
                            Text(
                                type.title
                            )
                            .tag(
                                type
                            )
                        }
                    }
                    DatePicker(
                        "Date",
                        selection: $viewModel.date,
                        displayedComponents: .date
                    )
                } header: {
                    HStack {
                        Image(
                            systemName: "note.text"
                        )
                        Text(
                            "Expense Details"
                        )
                    }
                }
                
                Section {
                    /*if let attachmentData = viewModel.expense.attachment {
                        if let attachmentInfo = AttachmentInfoTransformer().reverseTransformedValue(attachmentData) as? AttachmentInfo {
                            Text(attachmentInfo.fileName)
                                .onTapGesture {
                                    showingAttachmentPreview = true
                                }

                            Button(role: .destructive) {
                                viewModel.deleteAttachment()
                            } label: {
                                Label("Delete Attachment", systemImage: "trash")
                                    .foregroundStyle(.red)
                            }
                        } else {
                            Text("Attachment could not be decoded")
                        }
                    }

                    else {
                        Button {
                            showingAttachmentSheet = true
                        } label: {
                            HStack {
                                Image(
                                    systemName: "plus.circle.fill"
                                )
                                Text(
                                    "Add Attachment"
                                )
                            }
                        }
                    }*/
                } header: {
                    HStack {
                        Image(
                            systemName: "paperclip"
                        )
                        Text(
                            "Attachments"
                        )
                    }
                }
                
                Section {
                    /*if let locationData = viewModel.expense.location {
                        if let locationInfo = LocationInfoTransformer().reverseTransformedValue(locationData) as? LocationInfo {
                            VStack(alignment: .leading) {
                                Text("Latitude: \(locationInfo.latitude)")
                                Text("Longitude: \(locationInfo.longitude)")
                            }
                        } else {
                            Text("Location could not be decoded")
                        }
                    } else {
                        Text("No location selected")
                    }*/

                    Button {
                        showingLocationPicker = true
                    } label: {
                        HStack {
                            Image(
                                systemName: "location.fill"
                            )
                            Text(
                                "Select Location"
                            )
                        }
                    }
                    if viewModel.expense?.locationInfo != nil {
                        Button(
                            role: .destructive
                        ) {
                            selectedLocation = nil
                            viewModel
                                .cleanLocation()
                        } label: {
                            Label(
                                "Delete location",
                                systemImage: "trash"
                            )
                            .foregroundStyle(
                                .red
                            )
                        }
                    }
                } header: {
                    HStack {
                        Image(
                            systemName: "map"
                        )
                        Text(
                            "Location"
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(
                    placement: .confirmationAction
                ) {
                    Button("Save") {
                        viewModel.saveExpense()
                        dismiss()
                    }

                }
                
                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button(
                        "Close"
                    ) {
                        dismiss()
                    }
                }
            }
            .confirmationDialog(
                "Add Attachment",
                isPresented: $showingAttachmentSheet
            ) {
                Button(
                    "Take Photo"
                ) {
                    showingCamera = true
                }
                Button(
                    "Choose Photo"
                ) {
                    showingImagePicker = true
                }
                Button(
                    "Choose PDF"
                ) {
                    showingDocumentPicker = true
                }
                Button(
                    "Cancel",
                    role: .cancel
                ) {
                }
            }
            .sheet(
                isPresented: $showingImagePicker
            ) {
                ImagePicker(
                    completion: viewModel.handleImageSelection
                )
            }
            .sheet(
                isPresented: $showingCamera
            ) {
                Camera(
                    completion: viewModel.handleImageSelection
                )
            }
            .sheet(
                isPresented: $showingLocationPicker
            ) {
                LocationPickerView(
                    showingLocationPicker: $showingLocationPicker,
                    position: $position,
                    selectedLocation: $selectedLocation,
                    showingSaveDialog: $showingSaveDialog,
                    locationName: $locationName,
                    viewModel: viewModel
                )
            }
            .fileImporter(
                isPresented: $showingDocumentPicker,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                viewModel
                    .handleDocumentSelection(
                        result
                    )
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text(customError.title),
                    message: Text(customError.message),
                    dismissButton: .destructive(Text("Close")){
                        showErrorAlert = false
                    }
                )
            }
        }
    }
}
