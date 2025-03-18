//
//  ExpenseWebService.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 2/12/24.
//
/*
import Foundation
import SwiftUI

@Observable
final class ExpenseWebService {
    static let shared = ExpenseWebService()
    
    private init() {
    }
    
    private let baseUrl = "http://localhost:3000"
    private let apiService = "/expenses"
    
    private(
        set
    ) var expenses: [Expense] = []
    
    func add(
        _ expense: Expense
    ) async throws {
        do {
            let newExpense = try await createExpense(
                expense
            )
            self.expenses
                .append(
                    newExpense
                )
        } catch {
            throw CustomError(
                title: "Error adding expense",
                message: error.localizedDescription
            )
        }
    }
    
    func createExpense(
        _ expense: Expense
    ) async throws -> Expense {
        guard let url = URL(
            string: "\(baseUrl)\(apiService)"
        ) else {
            throw URLError(
                .badURL
            )
        }
        
        var request = URLRequest(
            url: url
        )
        request.httpMethod = "POST"
        request
            .setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        request.httpBody = try JSONEncoder()
            .encode(
                expense
            )
        
        let (
            data,
            response
        ) = try await URLSession.shared.data(
            for: request
        )
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(
                .badServerResponse
            )
        }
        if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
            throw NSError(
                domain: "ServerError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"
                ]
            )
        }
        
        do {
            return try JSONDecoder()
                .decode(
                    Expense.self,
                    from: data
                )
        } catch {
            throw NSError(
                domain: "DecodingError",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to decode response: \(error.localizedDescription)"
                ]
            )
        }
    }
    
    func load() async throws {
        do {
            let fetchedExpenses = try await fetchAllExpenses()
            self.expenses = fetchedExpenses
        } catch {
            throw CustomError(
                title: "Error loading expenses",
                message: error.localizedDescription
            )
        }
    }
    
    func fetchAllExpenses() async throws -> [Expense] {
        guard let url = URL(
            string: "\(baseUrl)\(apiService)"
        ) else {
            throw URLError(
                .badURL
            )
        }
        
        let (
            data,
            response
        ) = try await URLSession.shared.data(
            from: url
        )
        let decodedExpenses = try JSONDecoder().decode(
            [Expense].self,
            from: data
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(
                .badServerResponse
            )
        }
        
        if httpResponse.statusCode != 200 {
            throw NSError(
                domain: "ServerError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"
                ]
            )
        }
        
        return decodedExpenses
    }
    
    func update(
        _ expense: Expense
    ) async throws {
        do {
            try await updateExpense(
                expense
            )
            if let index = self.expenses.firstIndex(
                where: {
                    $0.id == expense.id
                }) {
                self.expenses[index] = expense
            }
        } catch {
            throw CustomError(
                title: "Error updating expense",
                message: error.localizedDescription
            )
        }
    }
    
    func updateExpense(
        _ expense: Expense
    ) async throws {
        guard let url = URL(
            string: "\(baseUrl)\(apiService)/\(expense.id.uuidString.lowercased())"
        ) else {
            throw URLError(
                .badURL
            )
        }
        
        var request = URLRequest(
            url: url
        )
        request.httpMethod = "PUT"
        request
            .setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        request.httpBody = try JSONEncoder()
            .encode(
                expense
            )
        
        let (
            _,
            response
        ) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(
                .badServerResponse
            )
        }
        
        if httpResponse.statusCode != 200 {
            throw NSError(
                domain: "ServerError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"
                ]
            )
        }
    }
    
    func delete(
        _ expense: Expense
    ) async throws {
        do {
            try await deleteExpense(
                expense
            )
            self.expenses
                .removeAll {
                    $0.id == expense.id
                }
        } catch {
            throw CustomError(
                title: "Error deleting expense",
                message: error.localizedDescription
            )
        }
    }
    
    func deleteExpense(
        _ expense: Expense
    ) async throws {
        guard let url = URL(
            string: "\(baseUrl)\(apiService)/\(expense.id.uuidString.lowercased())"
        ) else {
            throw URLError(
                .badURL
            )
        }
        
        var request = URLRequest(
            url: url
        )
        request.httpMethod = "DELETE"
        
        let (
            _,
            response
        ) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(
                .badServerResponse
            )
        }
        
        if httpResponse.statusCode != 200 && httpResponse.statusCode != 204 {
            throw NSError(
                domain: "ServerError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"
                ]
            )
        }
    }
    
    func delete(
        _ ids: [UUID]
    ) async throws {
        do {
            try await deleteExpenses(
                ids
            )
            self.expenses
                .removeAll {
                    ids.contains(
                        $0.id
                    )
                }
        } catch {
            throw CustomError(
                title: "Error deleting expenses",
                message: error.localizedDescription
            )
        }
    }
    
    func deleteExpenses(
        _ ids: [UUID]
    ) async throws {
        guard let url = URL(
            string: "\(baseUrl)\(apiService)"
        ) else {
            throw URLError(
                .badURL
            )
        }
        
        var request = URLRequest(
            url: url
        )
        request.httpMethod = "DELETE"
        request
            .setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        
        let idsStringArray = ids.map {
            $0.uuidString.lowercased()
        }
        let requestBody = ["ids": idsStringArray]
        request.httpBody = try JSONEncoder()
            .encode(
                requestBody
            )
        
        let (
            _,
            response
        ) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(
                .badServerResponse
            )
        }
        
        if httpResponse.statusCode != 200 && httpResponse.statusCode != 204 {
            throw NSError(
                domain: "ServerError",
                code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: "Request failed with status code \(httpResponse.statusCode)"
                ]
            )
        }
    }
}
*/
