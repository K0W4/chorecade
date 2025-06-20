//
//  Repository.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 06/06/25.
//

import CloudKit
import UIKit

struct Repository {
    
    static var userRecordID: CKRecord.ID?
    static var groupRecordID: CKRecord?
    static var userRecord: CKRecord?
    
    static func start() {
        Task {
            if let id = await fetchiCloudUserRecordID() {
                userRecordID = id
                print(id)
            }
            
            if let id = userRecordID {
                if let userRecord = await fetchRecordBy(id: id) {
                    Repository.userRecord = userRecord
                    print("UserRecord: \(userRecord)")
                }
            }
        }
    }
    
}

extension Repository {
    
    static private func fetchRecordBy(id: CKRecord.ID) async -> CKRecord? {
        await withCheckedContinuation { continuation in
            CKContainer.default().privateCloudDatabase.fetch(withRecordID: id) { record, error in
                if let error = error {
                    print("Error fetching record: \(error)")
                }
                continuation.resume(returning: record)
            }
        }
    }
    
    static private func fetchiCloudUserRecordID() async -> CKRecord.ID? {
        await withCheckedContinuation { continuation in
            CKContainer.default().fetchUserRecordID { recordID, error in
                if let error = error {
                    print("Error fetching user record ID: \(error)")
                }
                continuation.resume(returning: recordID)
            }
        }
    }
    
    static private func fetchGroupRecordByCode(groupCode: String) async -> CKRecord? {
        await withCheckedContinuation { continuation in
            let predicate = NSPredicate(format: "groupCode == %@", groupCode)
            let query = CKQuery(recordType: "Group", predicate: predicate)
            
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    print("Error fetching Group record: \(error)")
                    continuation.resume(returning: nil)
                    return
                }
                
                if let firstRecord = records?.first {
                    continuation.resume(returning: firstRecord)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    static private func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { identity, error in
            DispatchQueue.main.async {
                if let name = identity?.nameComponents?.givenName {
//                    self?.nameLabel.text = "\(name)"
                } else {
//                    self?.nameLabel.text = "Unknown"
                }
            }
        }
    }
    
    static private func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
