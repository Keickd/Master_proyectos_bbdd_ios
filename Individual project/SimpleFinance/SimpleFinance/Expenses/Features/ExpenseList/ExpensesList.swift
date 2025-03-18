//
//  ExpensesList.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 19/10/24.
//

import SwiftUI
import Combine
import PhotosUI
import UniformTypeIdentifiers
import Observation
import Charts

struct ExpenseListView: View {
    
  @State private var viewModel: ExpenseListViewModel?
  @State private var showExpenseForm = false
  @State private var showingAlert = false
  @State private var selectedExpense: Expense?
  @State private var expenseToDelete: Expense?
  @State private var selection = Set<UUID>()
  @State private var showErrorAlert = false
  @State private var deletingExpense: UUID? = nil
  @State private var deletingExpenses: Set<UUID> = []

    @State private var customError = CustomError(
        title: "Generic error",
        message: ""
    )
    
    @Environment(
        \.editMode
    ) private var editMode
    
    var body: some View {
        if let viewModel = viewModel {
            List(
                viewModel.expenses,
                selection: $selection
            ) { expense in
                ExpenseRow(
                    expense: expense
                ).id(expense.id)
                .offset(
                    x: deletingExpense == expense.id || deletingExpenses.contains(
                        expense.id!
                    ) ? -UIScreen.main.bounds.width : 0
                )
                .animation(
                    .easeInOut,
                    value: deletingExpense
                )
                .animation(
                    .easeInOut,
                    value: deletingExpenses
                )
                .swipeActions {
                    Button {
                        expenseToDelete = expense
                        showingAlert = true
                    } label: {
                        Label(
                            "Delete",
                            systemImage: "trash"
                        )
                    }
                    .tint(
                        .red
                    )
                    
                    Button {
                        selectedExpense = expense
                    } label: {
                        Label(
                            "Edit",
                            systemImage: "pencil"
                        )
                    }
                    .tint(
                        .blue
                    )
                }
            }
            .sheet(
                isPresented: $showExpenseForm
            ) {
                NewExpenseFormView()
                    .presentationDetents(
                        [.large]
                    )
                    .interactiveDismissDisabled(
                        true
                    )
            }
            .sheet(
                item: $selectedExpense
            ) { expense in
                EditExpenseFormView(
                    expense: expense
                )
                .presentationDetents(
                    [.large]
                )
                .interactiveDismissDisabled(
                    true
                )
            }
            .sheet(
                item: $selectedExpense
            ) { expense in
                EditExpenseFormView(
                    expense: expense
                )
                .presentationDetents(
                    [.large]
                )
                .interactiveDismissDisabled(
                    true
                )
            }
            .alert(
                "Delete Expense",
                isPresented: $showingAlert
            ) {
                Button(
                    "Delete",
                    role: .destructive
                ) {
                    Task {
                        if let expenseToDelete {
                            deletingExpense = expenseToDelete.id 
                            try? await Task
                                .sleep(
                                    nanoseconds: 300_000_000
                                )
                            viewModel
                                .delete(
                                    expenseToDelete
                                )
                            withAnimation {
                                deletingExpense = nil
                            }
                        }
                    }
                }
                Button(
                    "Cancel",
                    role: .cancel
                ) {
                    
                }
            }
            .alert(
                isPresented: $showErrorAlert
            ) {
                Alert(
                    title: Text(
                        customError.title
                    ),
                    message: Text(
                        customError.message
                    ),
                    dismissButton:
                            .destructive(
                                Text(
                                    "Close"
                                )
                            ){
                                showErrorAlert = false
                            }
                )
            }
            .navigationTitle(
                "Expenses"
            )
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading
                ) {
                    EditButton()
                }
                
                ToolbarItemGroup(
                    placement: .topBarTrailing
                ) {
                    if !selection.isEmpty {
                        Button {
                            deletingExpenses = selection
                            Task {
                                viewModel
                                    .delete(
                                        Array(
                                            selection
                                        )
                                    )
                                withAnimation {
                                    selection
                                        .removeAll()
                                    deletingExpenses
                                        .removeAll()
                                }
                            }
                        } label: {
                            Image(
                                systemName: "trash"
                            )
                        }
                        
                    }
                    
                    Button {
                        showExpenseForm = true
                    } label: {
                        Image(
                            systemName: "plus"
                        )
                    }
                }
            }
        } else {
            ProgressView()
                .task {
                    loadViewModel()
                }
                .alert(
                    isPresented: $showErrorAlert
                ) {
                    Alert(
                        title: Text(
                            customError.title
                        ),
                        message: Text(
                            customError.message
                        ),
                        dismissButton: 
                                .destructive(
                                    Text(
                                        "Close app"
                                    )
                                ){
                                    exit(
                                        EXIT_SUCCESS
                                    )

                            }
                                )
                            }
                    }

  }
    private func loadViewModel() {
        let model = ExpenseListViewModel(
            persistenceService: LocalPersistenceService.shared
          )
        viewModel = model
    }
}



#Preview {
  NavigationStack {
    ExpenseListView()
  }
}
