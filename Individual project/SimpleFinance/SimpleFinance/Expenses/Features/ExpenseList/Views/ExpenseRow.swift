//
//  ExpenseRow.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

struct ExpenseRow: View {
  let expense: Expense

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
          Text(expense.title ?? "")
          .font(.headline)
        Spacer()
          Text(expense.date ?? Date(), format: .dateTime.year().month().day())
          .foregroundColor(.secondary)
      }
      HStack {
        Text(expense.amount, format: .currency(code: "EUR"))
          .foregroundColor(.secondary)
        Spacer()
          if let expenseType = ExpenseType(rawValue: expense.type ?? ExpenseType.other.rawValue) {
              TypeBadge(type: expenseType)
          }
      }
    }
  }
}

#Preview {
    ExpenseRow(expense: Expense())
}
