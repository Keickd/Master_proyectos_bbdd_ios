//
//  CloudKitManager.swift
//  Note
//
//  Created by Libranner Leonel Santos Espinal on 7/2/25.
//
import CloudKit
import Observation

// MARK: - CloudKit Manager
@Observable
//TODO: Implement this
class CloudKitManager {
  private let database = CKContainer.default().publicCloudDatabase

  var notes: [Note] = []
  var error: Error?
  var isLoading = false

  // MARK: - CRUD Operations
  @MainActor
  func save(title: String, description: String, imageData: Data?) async throws -> Note {

  }

  @MainActor
  func fetch() async throws {

  }

  @MainActor
  func update(_ note: Note) async throws {

  }

  @MainActor
  func delete(_ note: Note) async throws {

  }
}
