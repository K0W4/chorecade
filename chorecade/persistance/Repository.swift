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
    static var currentGroup: Group?
    static var currentUserNickname: String?
    
    static func start() async {
        
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
        
        let groupCodes = userRecord["groupCode"] as? [String] ?? []
        
        if let groupCode = groupCodes.first {
            
            guard
                let groupRecordID = await fetchGroupRecordByCode(
                    groupCode: groupCode
                )
            else {
                print("Couldn't fetch iCloud group record")
                return
            }
            Repository.groupRecord = groupRecordID
            print("Current groupRecordID: \(groupRecordID)")
        }
        
    }
    
}

extension Repository {
    
    // MARK: Add points to current user
    static func addPointsToCurrentUser(_ points: Int) async {
        
        guard var userRecord = Repository.userRecord else {
            print("Couldn't fetch current user record")
            return
        }
        
        var currentPoints: Int = userRecord["points"] as? Int ?? 0
        currentPoints += points
        userRecord["points"] = currentPoints
        
        CKContainer.default().publicCloudDatabase.save(userRecord) {
            _, error in
            if let error = error {
                print("Error saving record: \(error)")
            }
        }
    }
    
    // MARK: Fetch record by ID
    static private func fetchRecordBy(id: CKRecord.ID) async -> CKRecord? {
        await withCheckedContinuation { continuation in
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) {
                record,
                error in
                if let error = error {
                    print("Error fetching record: \(error)")
                }
                continuation.resume(returning: record)
            }
        }
    }
    
    // MARK: Fetch iCloud user record
    static func fetchiCloudUserRecordID() async -> CKRecord.ID? {
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
    static private func fetchGroupRecordByCode(groupCode: String) async
    -> CKRecord?
    {
        await withCheckedContinuation { continuation in
            let predicate = NSPredicate(format: "groupCode == %@", groupCode)
            let query = CKQuery(recordType: "Group", predicate: predicate)
            
            CKContainer.default().publicCloudDatabase.perform(
                query,
                inZoneWith: nil
            ) { records, error in
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
    static func createUserModel(byRecord record: CKRecord) -> User {
        let groupCodes = record["groupCode"] as? [String] ?? []
        let nickname = record["nickname"] as? String ?? "No nickname"
        let recordID = record.recordID
        var avatarHead: UIImage? = nil
        var avatar: UIImage? = nil
        let points = record["points"] as? Int ?? 0
        
        if let avatarHeadAsset = record["avatarHead"] as? CKAsset,
           let imageData = try? Data(contentsOf: avatarHeadAsset.fileURL!) {
            avatarHead = UIImage(data: imageData)
        }
        
        if let avatarAsset = record["avatar"] as? CKAsset,
           let imageData = try? Data(contentsOf: avatarAsset.fileURL!) {
            avatar = UIImage(data: imageData)
        }
        
        return User(
            groupCodes: groupCodes,
            nickname: nickname,
            points: points,
            recordID: recordID,
            avatar: avatar,
            avatarHead: avatarHead,
        )
    }
    
    // MARK: Creates user model by recordID
    static func createUserModel(byRecordID recordID: CKRecord.ID) async
    -> User
    {
        if let record = await fetchRecordBy(id: recordID) {
            return createUserModel(byRecord: record)
        }
        return User(
            groupCodes: [],
            nickname: "Default NickName",
            points: 0,
            recordID: recordID
        )
    }
    
    // MARK: Creates user model by record
    static func createTaskModel(byRecord record: CKRecord) -> Tasks {
        let id = record.recordID
        let categoryID = record["category"] as? Int ?? 1
        let category = CategoriesList.allCategories[categoryID - 1]
        let description = record["description"] as? String ?? ""
        let user = record["userId"] as? String ?? ""
        let group = record["group"] as? String ?? ""
        var beforeImage: UIImage? = nil
        var afterImage: UIImage? = nil
        
        if let beforeAsset = record["photoBefore"] as? CKAsset,
           let imageData = try? Data(contentsOf: beforeAsset.fileURL!) {
            beforeImage = UIImage(data: imageData)
        }
        
        if let afterAsset = record["photoAfter"] as? CKAsset,
           let imageData = try? Data(contentsOf: afterAsset.fileURL!) {
            afterImage = UIImage(data: imageData)
        }
        
        
        return Tasks(
            category: category,
            description: description,
            user: CKRecord.ID(recordName: user),
            group: group,
            beforeImage: beforeImage,
            afterImage: afterImage
        )
    }
    
    static func createTaskModel(byRecordID recordID: CKRecord.ID) async
    -> Tasks {
        if let record = await fetchRecordBy(id: recordID) {
            return createTaskModel(byRecord: record)
        }
        return Tasks(category: Category(id: 0, title: "", points: 0, level: 0, type: .bathroom) , description: "", user: CKRecord.ID(), group: "", beforeImage: nil, afterImage: nil)
    }
    
    // MARK: Creates group model by record
    static func createGroupModel(byRecord record: CKRecord) async -> Group {
        let id = record.recordID
        let name = record["name"] as? String ?? "Default name"
        let startDate = record["startDate"] as? Date ?? Date()
        let duration = record["duration"] as? Int ?? 1
        let groupCode = record["groupCode"] as? String ?? "Default groupCode"
        let membersString = record["members"] as? [String] ?? []
        let prize = record["prize"] as? String ?? "Default prize"
        var groupImage: UIImage? = nil
        
        if let groupImageAsset = record["groupImage"] as? CKAsset,
           let imageData = try? Data(contentsOf: groupImageAsset.fileURL!) {
            groupImage = UIImage(data: imageData)
        }
        
        var members: [User] = []
        for memberString in membersString {
            let recordID = CKRecord.ID(recordName: memberString)
            let user = await createUserModel(byRecordID: recordID)
            members.append(user)
        }
        
        // Fetch tasks dynamically using groupRef instead of relying on taskString
        let taskRecords = try? await fetchTasksForGroup(record.recordID)
        var taskList: [Tasks] = []
        for taskRecord in taskRecords ?? [] {
            let task = createTaskModel(byRecord: taskRecord)
            taskList.append(task)
        }
        
        let createdBy = record["createdBy"] as? String
        
        return Group(
            id: id,
            name: name,
            startDate: Date(),
            duration: duration,
            createdBy: createdBy,
            prize: prize,
            groupImage: groupImage,
            users: members,
            tasks: taskList,
            groupCode: groupCode
        )
    }
    
    // MARK: Fetches every user in a group
    static func fetchUsersForGroup(
        groupRecordID: CKRecord.ID,
        completion: @escaping ([CKRecord]) -> Void
    ) {
        let predicate = NSPredicate(
            format: "groupReference == %@",
            groupRecordID
        )
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(
            query,
            inZoneWith: nil
        ) { records, error in
            DispatchQueue.main.async {
                if let records = records {
                    completion(records)
                } else {
                    print(
                        "Erro ao buscar usuários: \(error?.localizedDescription ?? "Desconhecido")"
                    )
                    completion([])
                }
            }
        }
    }
    
    // MARK: Fetches every group a user is in (async version)
    static func fetchGroupsForUser(userID: String) async throws -> [CKRecord] {
        let predicate = NSPredicate(format: "ANY members == %@", userID)
        let query = CKQuery(recordType: "Group", predicate: predicate)
        let publicDB = CKContainer.default().publicCloudDatabase

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
    
    // MARK: Gets user profile image
    static func getUserImage(from record: CKRecord) -> UIImage? {
        if let asset = record["profileImage"] as? CKAsset,
           let data = try? Data(contentsOf: asset.fileURL!)
        {
            return UIImage(data: data)
        }
        return UIImage(named: "defaultImage")
    }
    
    // MARK: Add task to group
    static func addTask(
        toGroupWithCode groupCode: String,
        category: Int,
        description: String,
        points: Int,
        userId: CKRecord.ID,
        photoBefore: UIImage?,
        photoAfter: UIImage?
    ) async throws -> CKRecord {
        let publicDB = CKContainer.default().publicCloudDatabase
        
        // 1. Busca o registro do grupo pelo código
        let groupRecord: CKRecord = try await withCheckedThrowingContinuation {
            continuation in
            let predicate = NSPredicate(format: "groupCode == %@", groupCode)
            let query = CKQuery(recordType: "Group", predicate: predicate)
            publicDB.perform(query, inZoneWith: nil) { results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let group = results?.first {
                    continuation.resume(returning: group)
                } else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "GroupNotFound",
                            code: 404,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Group not found"
                            ]
                        )
                    )
                }
            }
        }
        
        // 2. Cria o registro da tarefa
        let taskRecord = CKRecord(recordType: "Task")
        taskRecord["category"] = category as NSNumber
        taskRecord["description"] = description as NSString
        taskRecord["points"] = points as NSNumber
        taskRecord["userId"] = userId.recordName as NSString
        taskRecord["groupCode"] = groupCode as NSString
        taskRecord["groupRef"] = CKRecord.Reference(
            recordID: groupRecord.recordID,
            action: .none
        )
        
        // 3. Adiciona fotos, se houver
        if let photoBefore = photoBefore,
           let beforeURL = saveImageToTempDirectory(
            image: photoBefore,
            name: "before.jpg"
           )
        {
            taskRecord["photoBefore"] = CKAsset(fileURL: beforeURL)
        }
        if let photoAfter = photoAfter,
           let afterURL = saveImageToTempDirectory(
            image: photoAfter,
            name: "after.jpg"
           )
        {
            taskRecord["photoAfter"] = CKAsset(fileURL: afterURL)
        }
        
        // 4. Salva a tarefa no banco e atualiza o grupo
        return try await withCheckedThrowingContinuation { continuation in
            publicDB.save(taskRecord) { savedRecord, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let savedRecord = savedRecord {
                    // Atualiza o campo 'tasks' do grupo
                    var currentTasks = groupRecord["tasks"] as? [String] ?? []
                    currentTasks.append(savedRecord.recordID.recordName)
                    groupRecord["tasks"] = currentTasks
                    
                    // Salva o grupo novamente com o campo atualizado
                    publicDB.save(groupRecord) { _, groupError in
                        if let groupError = groupError {
                            continuation.resume(throwing: groupError)
                        } else {
                            continuation.resume(returning: savedRecord)
                        }
                    }
                } else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "SaveTaskError",
                            code: 500,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "Unknown error when saving task"
                            ]
                        )
                    )
                }
            }
        }
    }
    
    static func updateUserNickname(_ nickname: String, completion: ((Bool) -> Void)? = nil) {
        guard let userRecordID = userRecordID else {
            print("userRecordID não disponível")
            completion?(false)
            return
        }
        
        // Busca o registro atual do usuário
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: userRecordID) { record, error in
            if let error = error {
                print("Erro ao buscar registro do usuário: \(error.localizedDescription)")
                completion?(false)
                return
            }
            
            guard let record = record else {
                print("Registro do usuário não encontrado.")
                completion?(false)
                return
            }
            
            // Atualiza o nickname no registro
            record["nickname"] = nickname as CKRecordValue
            
            // Salva a alteração no banco
            CKContainer.default().publicCloudDatabase.save(record) { savedRecord, saveError in
                if let saveError = saveError {
                    print("Erro ao salvar nickname: \(saveError.localizedDescription)")
                    completion?(false)
                    return
                }
                
                // Atualiza a variável local
                currentUserNickname = nickname
                print("Nickname atualizado com sucesso para: \(nickname)")
                completion?(true)
            }
        }
    }
    
    // MARK: addAvatar
    static func addUserAvatar(avatar: UIImage, avatarHead: UIImage, completion: ((Bool) -> Void)? = nil) {
        guard let userRecordID = userRecordID else {
            print("userRecordID não disponível")
            completion?(false)
            return
        }
        
        // Busca o registro atual do usuário
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: userRecordID) { record, error in
            if let error = error {
                print("Erro ao buscar registro do usuário: \(error.localizedDescription)")
                completion?(false)
                return
            }
            
            guard let record = record else {
                print("Registro do usuário não encontrado.")
                completion?(false)
                return
            }
            
            // Atualiza o avatar no registro usando CKAsset
            if let avatarURL = saveImageToTempDirectory(image: avatar, name: "avatar.jpg") {
                record["avatar"] = CKAsset(fileURL: avatarURL)
            }

            if let avatarHeadURL = saveImageToTempDirectory(image: avatarHead, name: "avatarHead.jpg") {
                record["avatarHead"] = CKAsset(fileURL: avatarHeadURL)
            }
            
            // Salva a alteração no banco
            CKContainer.default().publicCloudDatabase.save(record) { savedRecord, saveError in
                if let saveError = saveError {
                    print("Erro ao salvar avatar: \(saveError.localizedDescription)")
                    completion?(false)
                    return
                }
                
                print("Avatar atualizado com sucesso.")
                completion?(true)
            }
        }
    }
    
    static func getTasksForCurrentGroup() -> [Tasks]
    {
        if let group = currentGroup {
            return group.tasks
        }
        return []
    }
    
    static private func saveImageToTempDirectory(image: UIImage, name: String)
    -> URL?
    {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(
            UUID().uuidString + "_" + name
        )
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    // MARK: - Verifica se nickname já existe
    static func nicknameExists(_ nickname: String) async -> Bool {
        let predicate = NSPredicate(format: "nickname == %@", nickname)
        let query = CKQuery(recordType: "User", predicate: predicate)

        return await withCheckedContinuation { continuation in
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    print("Erro ao verificar nickname: \(error)")
                    continuation.resume(returning: false)
                    return
                }

                if let records = records, !records.isEmpty {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }

    
    
    // MARK: Fetch all tasks from group using groupRef
    static func fetchTasksForGroup(_ groupRecordID: CKRecord.ID) async throws -> [CKRecord] {
        let publicDB = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(format: "groupRef == %@", groupRecordID)
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
