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
    static var userRecord: CKRecord?
    static var groupRecord: CKRecord?
    
    static func start() {
        Task {
            guard let id = await fetchiCloudUserRecordID() else {
                print("Couldn't fetch iCloud user record ID")
                return
            }
            userRecordID = id
            print("Current user ID: \(id)")
        
            
            guard let userRecord = await fetchRecordBy(id: id) else {
                print("Couldn't fetch iCloud user record")
                return
            }
            Repository.userRecord = userRecord
            print("Current userRecord: \(userRecord)")
            
            guard let groupRecordID = await fetchGroupRecordByCode(groupCode: userRecord["groupCode"] as? String ?? "Default group code") else {
                print("Couldn't fetch iCloud group record")
                return
            }
            Repository.groupRecord = groupRecordID
            print("Current groupRecordID: \(groupRecordID)")
        }
    }
    
}

extension Repository {
    // MARK: Fetch record by ID
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
    
    // MARK: Fetch iCloud user record
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
    
    // MARK: Fetch group record by code
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
    
    // MARK: Creates user model by record
    private static func createUserModel(byRecord record: CKRecord) -> User {
        let groupCode = record["groupCode"] as? String ?? "No group"
        let nickname = record["nickname"] as? String ?? "No nickname"
        let recordID = record.recordID
        return User(groupCode: groupCode, nickname: nickname, recordID: recordID)
    }
    
    // MARK: Creates user model by recordID
    private static func createUserModel(byRecordID recordID: CKRecord.ID) async -> User {
        if let record = await fetchRecordBy(id: recordID) {
            return createUserModel(byRecord: record)
        }
        return User(nickname: "Default NickName", recordID: recordID)
    }
    
//    // MARK: Creates group model by record
//    private static func createGroupModel(byRecord record: CKRecord) async -> Group {
//        let name = record["name"] as? String ?? "Default name"
//        let startDate = record["startDate"] as? Date ?? Date()
//        let duration = record["duration"] as? Int ?? 1
//        let groupCode = record["groupCode"] as? String ?? "Default groupCode"
//        let membersString = record["members"] as? [String] ?? []
//        let prize = record["prize"] as? String ?? "Default prize"
//        let tasksStrig = record["tasks"] as? [String] ?? []
//        
//        var members: [User] = []
//        for memberString in membersString {
//            let recordID = CKRecord.ID(recordName: memberString)
//            let user = await createUserModel(byRecordID: recordID)
//            members.append(user)
//        }
//        return Group(name: name, startDate: startDate, duration: duration, groupCode: groupCode, members: members, prize: prize, tasks: tasksStrig)
//    }
    
    
    // MARK: Add task to group
    static func addTask(
        toGroupWithCode groupCode: String,
        category: String,
        description: String,
        points: Int,
        userId: String,
        photoBefore: UIImage?,
        photoAfter: UIImage?
    ) async throws -> CKRecord {
        let publicDB = CKContainer.default().publicCloudDatabase
        
        // 1. Busca o registro do grupo pelo código
        let groupRecord: CKRecord = try await withCheckedThrowingContinuation { continuation in
            let predicate = NSPredicate(format: "groupCode == %@", groupCode)
            let query = CKQuery(recordType: "Group", predicate: predicate)
            publicDB.perform(query, inZoneWith: nil) { results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let group = results?.first {
                    continuation.resume(returning: group)
                } else {
                    continuation.resume(throwing: NSError(domain: "GroupNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Group not found"]))
                }
            }
        }
        
        // 2. Cria o registro da tarefa
        let taskRecord = CKRecord(recordType: "Task")
        taskRecord["category"] = category as NSString
        taskRecord["description"] = description as NSString
        taskRecord["points"] = points as NSNumber
        taskRecord["userId"] = userId as NSString
        taskRecord["groupCode"] = groupCode as NSString
        taskRecord["groupRef"] = CKRecord.Reference(recordID: groupRecord.recordID, action: .none)
        
        // 3. Adiciona fotos, se houver
        if let photoBefore = photoBefore, let beforeURL = saveImageToTempDirectory(image: photoBefore, name: "before.jpg") {
            taskRecord["photoBefore"] = CKAsset(fileURL: beforeURL)
        }
        if let photoAfter = photoAfter, let afterURL = saveImageToTempDirectory(image: photoAfter, name: "after.jpg") {
            taskRecord["photoAfter"] = CKAsset(fileURL: afterURL)
        }
        
        // 4. Salva a tarefa no banco
        return try await withCheckedThrowingContinuation { continuation in
            publicDB.save(taskRecord) { savedRecord, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let savedRecord = savedRecord {
                    continuation.resume(returning: savedRecord)
                } else {
                    continuation.resume(throwing: NSError(domain: "SaveTaskError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown error when saving task"]))
                }
            }
        }
    }

    static private func saveImageToTempDirectory(image: UIImage, name: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString + "_" + name)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    
    static private func createGroupModel() {
        
    }
    
    // MARK: Fetch all tasks from group
    static private func fetchTasks(forGroupCode groupCode: String) async throws -> [CKRecord] {
        let publicDB = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(format: "groupCode == %@", groupCode)
        let query = CKQuery(recordType: "Task", predicate: predicate)
        
        return try await withCheckedThrowingContinuation { continuation in
            publicDB.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: records ?? [])
                }
            }
        }
    }
}
