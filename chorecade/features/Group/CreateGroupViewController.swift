//
//  CreateGroupViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 20/06/25.
//

import CloudKit
import UIKit

class CreateGroupViewController: UIViewController {
    
    // MARK: - Components
    lazy var codeTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Group Code"
        tf.backgroundColor = .systemBackground
        tf.borderStyle = .roundedRect
        tf.textColor = .label
        return tf
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Join Group", for: .normal)
        button.addTarget(self, action: #selector(handleJoinButton), for: .touchUpInside)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var joinStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [codeTextField, joinButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Group Name"
        tf.backgroundColor = .systemBackground
        tf.borderStyle = .roundedRect
        tf.textColor = .label
        return tf
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Group", for: .normal)
        button.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var createStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, createButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [joinStack, createStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 32
        return stack
    }()
    

    // MARK: - Scene
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        Repository.start()
        
        setup()
        
//        fetchGroupRecord(byCode: "01383B")
    }
    
    
    // MARK: - Button functions
    @objc func handleJoinButton() {
        let code = codeTextField.text ?? ""
        codeTextField.text = ""
        Task {
            do {
                let updatedGroup = try await joinGroupAndSaveUser(withCode: code)
                print("Joined group! Group name: \(updatedGroup["name"] ?? "")")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Joined Group",
                        message: "You successfully joined: \(updatedGroup["name"] ?? "")",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            } catch {
                print("Failed to join group: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Could not join group: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func handleCreateButton() {
        let name = nameTextField.text ?? ""
        nameTextField.text = ""
        Task {
            do {
                let newGroupCode = try await createGroup(groupName: name)
                print("Group created! Code: \(newGroupCode)")

                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Group Created",
                        message: "Your group code is: \(newGroupCode)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            } catch {
                print("Error creating group: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to create group: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

// MARK: - View Code Protocol
extension CreateGroupViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(mainStack)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - CloudKit related functions
extension CreateGroupViewController {
    
    
    // MARK: Create group
    func createGroup(groupName: String) async throws -> String {
        let publicDB = CKContainer.default().publicCloudDatabase
        let groupCode = String(UUID().uuidString.prefix(6)).uppercased()

        let userRecordID: CKRecord.ID = try await withCheckedThrowingContinuation { continuation in
            CKContainer.default().fetchUserRecordID { userRecordID, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let userRecordID = userRecordID {
                    continuation.resume(returning: userRecordID)
                } else {
                    continuation.resume(throwing: NSError(domain: "CloudKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user record ID found."]))
                }
            }
        }

        let userIDString = userRecordID.recordName

        let groupRecord = CKRecord(recordType: "Group")
        groupRecord["name"] = groupName as NSString
        groupRecord["groupCode"] = groupCode as NSString
        groupRecord["members"] = [userIDString] as NSArray

        // Step: Update user's groupCode
        addGroupCodeTo(user: userIDString, code: groupCode)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            publicDB.save(groupRecord) { savedRecord, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if savedRecord != nil {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: NSError(domain: "CloudKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error saving group."]))
                }
            }
        }

        return groupCode
    }
    
    func addGroupCodeTo(user: String, code: String) {
            let publicDB = CKContainer.default().publicCloudDatabase
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: user)) { record, error in
                if let error = error {
                    print("Error fetching user record: \(error)")
                    return
                }
                
                guard let record = record else {
                    print("User record not found.")
                    return
                }
                
                record["groupCode"] = code as NSString
                
                publicDB.save(record) { _, saveError in
                    if let saveError = saveError {
                        print("Error saving user record: \(saveError)")
                    }
                }
            }
        }
    
    func joinGroupAndSaveUser(withCode code: String) async throws -> CKRecord {
        let publicDB = CKContainer.default().publicCloudDatabase
        
        // Step 1: Fetch the group record by code
        let groupRecord: CKRecord = try await withCheckedThrowingContinuation { continuation in
            let predicate = NSPredicate(format: "groupCode == %@", code)
            let query = CKQuery(recordType: "Group", predicate: predicate)
            
            publicDB.perform(query, inZoneWith: nil) { results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let group = results?.first else {
                    let notFoundError = NSError(
                        domain: "GroupNotFound",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Group with code \(code) not found."]
                    )
                    continuation.resume(throwing: notFoundError)
                    return
                }
                
                continuation.resume(returning: group)
            }
        }
        
        // Step 2: Add current user to group's members
        var members = groupRecord["members"] as? [String] ?? []
        
        if let currentUserID = Repository.userRecordID?.recordName {
            if !members.contains(currentUserID) {
                members.append(currentUserID)
                groupRecord["members"] = members as NSArray
            }
        }
        
        
        // Step 3: Save updated group record
        let savedGroup: CKRecord = try await withCheckedThrowingContinuation { continuation in
            publicDB.save(groupRecord) { savedRecord, saveError in
                if let saveError = saveError {
                    continuation.resume(throwing: saveError)
                } else if let savedRecord = savedRecord {
                    continuation.resume(returning: savedRecord)
                }
            }
        }
        
        // Step 4: Update user record with group code
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            guard let currentUserID = Repository.userRecordID?.recordName else {
                fatalError("Current user record ID not set.")
            }
            
            let userID = currentUserID
            let userRecordID = CKRecord.ID(recordName: userID)
            
            publicDB.fetch(withRecordID: userRecordID) { userRecord, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let userRecord = userRecord else {
                    continuation.resume(throwing: NSError(domain: "UserNotFound", code: 404, userInfo: nil))
                    return
                }
                
                userRecord["groupCode"] = code as NSString
                publicDB.save(userRecord) { _, saveError in
                    if let saveError = saveError {
                        continuation.resume(throwing: saveError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
        }
        
        return savedGroup
    }
    
    // MARK: Fetch Group Record
    /*
    private func fetchGroupRecord(byCode code: String) {
        CloudKit.fetchGroupRecord(byCode: code) { result in
            switch result {
            case .success(let groupRecord):
                print("Group found with name: \(groupRecord["name"] ?? "Unnamed")")
                
                if let members = groupRecord["members"] as? [String] {
                    print("Group has \(members.count) members")
                    for memberID in members {
                        CloudKit.discoveriCloudUser(id: memberID) { result in
                            print(result ?? "fuck")
                        }
                        print("Member ID: \(memberID)")
                    }
                } else {
                    print("Group has no members.")
                }
                
            case .failure(let error):
                print("Failed to fetch group: \(error.localizedDescription)")
            }
        }
    }
    
    private func discoverUserIdentity(byID userID: CKRecord.ID) {
        
    }
     */
}
