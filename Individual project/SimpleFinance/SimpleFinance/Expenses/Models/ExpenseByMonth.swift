//
//  ExpenseByMonth.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 1/11/24.
//

import Foundation

struct ExpenseByMonth: Identifiable {
  let id = UUID()
  let month: String
  let total: Double
}
