//
//  CreateGroupViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 20/06/25.
//

import CloudKit
import UIKit

class CreateGroupViewController: UIViewController {
    
    // MARK: Variables
    var usersByGroup: [[CKRecord]] = []
    var groupNames: [String] = []
    var groupRecords: [CKRecord] = []
    var loadingOverlay: LoadingOverlay?
    
    // MARK: - Components
    private lazy var groupLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 48)
        label.textAlignment = .center
        label.text = "Group"
        label.textColor = .black
        return label
    }()
    
    private lazy var createGroupButton = Components.getButton(content: " Create Group + ", action: #selector( CreateGroupViewController.handleCreateButton), font: UIFont(name: "Jersey10-Regular", size: 24))
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupLabel, createGroupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var pasteLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Paste code:"
        label.textColor = .black
        return label
    }()
    
    private lazy var codeTextField: UITextField = {
        let textField = Components.getTextField(placeholder: "Ex: #6AE8T")
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pasteLabel, codeTextField])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            codeTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()
    
    lazy var emptyState: GroupEmptyState = {
        let view = GroupEmptyState()
        view.descriptionText = "Click on \"Create Group\" to create a new group"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var groupsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "GroupsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 108 
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
//        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        return tableView
    }()
    

    // MARK: - Scene
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        codeTextField.delegate = self
        
        Repository.start()
            
        CKContainer.default().accountStatus { status, error in
            print("Account status:", status.rawValue)
            DispatchQueue.main.async {
                if status != .available {
                    let alert = UIAlertController(
                        title: "iCloud not available",
                        message: "You need to be logged in to iCloud to continue.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Close", style: .destructive) { _ in
                        exit(0)
                    })
                    self.present(alert, animated: true)
                    return
                }
                self.requestiCloudPermission { granted in
                    if !granted {
                        let alert = UIAlertController(
                            title: "Permission denied",
                            message: "You need to allow this app to access your iCloud to continue.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Close", style: .destructive) { _ in
                            exit(0)
                        })
                        self.present(alert, animated: true)
                    } else {
                        // Só busca userID e carrega grupos se permissão concedida!
                        Task {
                            let recordID = await Repository.fetchiCloudUserRecordID()
                            if let recordID = recordID {
                                print("User recordID carregado:", recordID.recordName)
                                self.loadGroupsAndUsersForCurrentUser()
                                print("group Names: \(self.groupNames)")
                                self.updateLayout()
                                self.setup()
                            } else {
                                print("Erro: não conseguiu obter o userRecordID")
                            }
                        }
                    }
                }
            }
        }
//        fetchGroupRecord(byCode: "01383B")
    }
    
    
    // MARK: - Button functions
//    @objc func handleJoinButton() {
//        let code = codeTextField.text ?? ""
//        codeTextField.text = ""
//        Task {
//            do {
//                let updatedGroup = try await joinGroupAndSaveUser(withCode: code)
//                print("Joined group! Group name: \(updatedGroup["name"] ?? "")")
//
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(
//                        title: "Joined Group",
//                        message: "You successfully joined: \(updatedGroup["name"] ?? "")",
//                        preferredStyle: .alert
//                    )
//                    alert.addAction(UIAlertAction(title: "OK", style: .default))
//                    self.present(alert, animated: true)
//                }
//            } catch {
//                print("Failed to join group: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(
//                        title: "Error",
//                        message: "Could not join group: \(error.localizedDescription)",
//                        preferredStyle: .alert
//                    )
//                    alert.addAction(UIAlertAction(title: "OK", style: .default))
//                    self.present(alert, animated: true)
//                }
//            }
//        }
//    }
    
    @objc func handleCreateButton() {
        
        let modalVC = ModalCreateGroupViewController()
        modalVC.modalPresentationStyle = .automatic
        modalVC.delegate = self
        self.present(modalVC, animated: true)
//        nameTextField.text = ""
//        Task {
//            do {
//                let newGroupCode = try await createGroup(groupName: name)
//                print("Group created! Code: \(newGroupCode)")
//
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(
//                        title: "Group Created",
//                        message: "Your group code is: \(newGroupCode)",
//                        preferredStyle: .alert
//                    )
//                    alert.addAction(UIAlertAction(title: "OK", style: .default))
//                    self.present(alert, animated: true)
//                }
//            } catch {
//                print("Error creating group: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(
//                        title: "Error",
//                        message: "Failed to create group: \(error.localizedDescription)",
//                        preferredStyle: .alert
//                    )
//                    alert.addAction(UIAlertAction(title: "OK", style: .default))
//                    self.present(alert, animated: true)
//                }
//            }
//        }
    }
    
    // MARK: Functions
    
    private func requestiCloudPermission(completion: @escaping (Bool) -> Void) {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { status, error in
            DispatchQueue.main.async {
                if status == .granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func updateLayout() {
        groupsTableView.removeFromSuperview()
        emptyState.removeFromSuperview()
        addSubviews()
        setupConstraints()
        groupsTableView.reloadData()
    }
    
    private func loadGroupsAndUsersForCurrentUser() {

        guard let currentUserID = Repository.userRecordID?.recordName else {
                print("currentUserID NIL!");
                return
            }
        Repository.fetchGroupsForUser(userID: currentUserID) { [weak self] groups in
            self?.groupRecords = groups
            self?.groupNames = groups.compactMap { $0["name"] as? String }
            self?.usersByGroup = Array(repeating: [], count: groups.count)
            let total = groups.count
            var fetched = 0

            for (i, group) in groups.enumerated() {
                Repository.fetchUsersForGroup(groupRecordID: group.recordID) { users in
                    self?.usersByGroup[i] = users
                    fetched += 1
                    if fetched == total {
                        DispatchQueue.main.async {
                            self?.updateLayout()
                            self?.loadingOverlay?.hide()
                            self?.loadingOverlay = nil
                        }
                    }
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            // Exemplo: pode ajustar o height da tableView conforme o contentSize
            // let newContentSize = change?[.newKey] as? CGSize
            // print("Novo contentSize:", newContentSize)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        groupsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
}

// MARK: - View Code Protocol
extension CreateGroupViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(topStackView)
        view.addSubview(textFieldStackView)
        
        if groupNames.isEmpty {
            view.addSubview(emptyState)
        } else {
            view.addSubview(groupsTableView)
        }
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
    
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110.25),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110.25),
            
            textFieldStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 40),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
        if groupNames.isEmpty {
            NSLayoutConstraint.activate([
                emptyState.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor),
                emptyState.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                emptyState.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emptyState.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                groupsTableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 16),
                groupsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                groupsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                groupsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
        }
    }
}

// MARK: - CloudKit related functions
extension CreateGroupViewController {
    
    static func addGroupCodeTo(user: String, code: String) {
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
    
    func didEnterGroup() {
        loadingOverlay = LoadingOverlay.show(on: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadGroupsAndUsersForCurrentUser()
        }
    }
}

extension CreateGroupViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as? GroupsTableViewCell else {
            return UITableViewCell()
        }
        let users = usersByGroup[indexPath.row]
        let groupName = groupNames[indexPath.row]
        cell.configure(with: users)
        cell.groupTitleLabel.text = groupName
        let groupRecord = groupRecords[indexPath.row]
        if let asset = groupRecord["groupImage"] as? CKAsset,
           let fileURL = asset.fileURL,
           let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            cell.groupImage.image = image
        } else {
            cell.groupImage.image = UIImage(named: "defaultImage")
        }
        
        return cell
    }
}

extension CreateGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension CreateGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Fecha o teclado
        guard textField == codeTextField else { return true }
        guard let code = codeTextField.text, !code.isEmpty else { return true }

        loadingOverlay = LoadingOverlay.show(on: self.view)
        Task {
            do {
                let group = try await joinGroupAndSaveUser(withCode: code)
                DispatchQueue.main.async {
                    self.loadingOverlay?.hide()
                    self.loadingOverlay = nil
                    let alert = UIAlertController(
                        title: "Entered Group",
                        message: "You entered the group: \(group["name"] as? String ?? "")",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    self.didEnterGroup()
                }
            } catch {
                DispatchQueue.main.async {
                    self.loadingOverlay?.hide()
                    self.loadingOverlay = nil
                    let alert = UIAlertController(
                        title: "Erro",
                        message: "Não foi possível entrar no grupo.\n\(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }

        return true
    }
}

extension CreateGroupViewController: ModalCreateGroupDelegate {
    func didCreateGroup() {
        loadingOverlay = LoadingOverlay.show(on: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadGroupsAndUsersForCurrentUser()
        }
    }
}

