//
//  GroupDetailsViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 24/06/25.
//

import UIKit
import CloudKit

class GroupDetailsViewController: UIViewController {
    
    // MARK: Variables
    var groupModel: Group?
    var members: [(id: String, nickname: String, image: UIImage?)] = []
    var isCurrentUserCreator: Bool = false
    
    // MARK: Components
    private lazy var headerView: ModalHeader = {
        var header = ModalHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Group Details"
        header.cancelButton.setTitleColor(.background, for: .normal)
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    lazy var groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var groupLabel = Components.getLabel(content: "", font: Fonts.nameTask)
    
    lazy var editLabelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editLabelTapped), for: .touchUpInside)
        let image = UIImage(systemName: "pencil")
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .label
        return button
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupLabel, editLabelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var codeLabel = Components.getLabel(content: "Code:", font: UIFont(name: "Jersey10-Regular", size: 29))
    
    lazy var copyCodeLabel = Components.getLabel(content: "", font: UIFont(name: "SFProText-Regular", size: 20))
    
    lazy var codeCopiedLabel = Components.getLabel(content: " Copied!", font: UIFont(name: "SFProText-Regular", size: 20))
    
    lazy var copyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "document")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.tintColor = .label
        return button
    }()
    
    lazy var codeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [codeLabel, copyCodeLabel, codeCopiedLabel, copyButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.setCustomSpacing(0, after: codeLabel)
        stackView.setCustomSpacing(5, after: copyCodeLabel)
        stackView.spacing = 8
        codeCopiedLabel.isHidden = true
        return stackView
    }()
    
    lazy var prizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont(name: "Jersey10-Regular", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "Winner won't pay for the cinema"
        return label
    }()
    
    lazy var editPrizeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editPrizeTapped), for: .touchUpInside)
        let image = UIImage(systemName: "pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var trophyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "trophy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var prizeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trophyImage, prizeLabel, editPrizeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = .clear
        stackView.heightAnchor.constraint(equalToConstant: 47).isActive = true
        stackView.layer.borderColor = UIColor(named: "primaryPurple300")?.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, codeStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.setCustomSpacing(10, after: labelStackView)
        return stackView
    }()
    
    lazy var tableViewHeader: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Members"
        headerLabel.font = UIFont(name: "Jersey10-Regular", size: 24)
        headerLabel.textColor = .label
        headerLabel.textAlignment = .left
        headerLabel.backgroundColor = .clear
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    lazy var usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupDetailsTableViewCell.self, forCellReuseIdentifier: GroupDetailsTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    // MARK: Override ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setup()
        
        let appearance = UINavigationBarAppearance()

        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(named: "primary-purple-300") ?? .systemPink
        ]

        navigationController?.navigationBar.tintColor = UIColor(named: "primary-purple-300")

        navigationController?.navigationBar.standardAppearance = appearance
                
        if let group = groupModel {
            groupLabel.text = group.name
            copyCodeLabel.text = " " + group.groupCode

            if let image = group.groupImage {
                groupImage.image = image
            }

            // Verifica se o usuário atual é o criador do grupo
            if let createdByID = group.createdBy {
                CKContainer.default().fetchUserRecordID { currentUserID, error in
                    guard let currentUserID = currentUserID, error == nil else {
                        print("Erro ao buscar o ID do usuário atual: \(error?.localizedDescription ?? "Desconhecido")")
                        return
                    }

                    self.isCurrentUserCreator = (currentUserID.recordName == createdByID.recordName)
                    print("Meu recordName: \(currentUserID.recordName)")
                    print("Criador do grupo: \(createdByID.recordName)")
                    print("É criadora? \(self.isCurrentUserCreator)")
                    DispatchQueue.main.async {
                        self.editPrizeButton.isHidden = !self.isCurrentUserCreator
                        self.usersTableView.reloadData()
                    }
                }
            } else {
                self.editPrizeButton.isHidden = true
            }

            loadMembers(for: group)
        }
    }
    
    // MARK: Functions
    @objc func addButtonTapped() {
        print("Add button tapped")
    }
    
    @objc func editLabelTapped() {
        let alert = UIAlertController(title: "Edit Group Name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.groupLabel.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let newName = alert.textFields?.first?.text,
                  let groupID = self.groupModel?.id else { return }

            self.groupLabel.text = newName

            CKContainer.default().publicCloudDatabase.fetch(withRecordID: groupID) { record, error in
                guard let record = record, error == nil else {
                    print("Erro ao buscar grupo: \(error?.localizedDescription ?? "Desconhecido")")
                    return
                }

                record["name"] = newName
                CKContainer.default().publicCloudDatabase.save(record) { _, saveError in
                    if let saveError = saveError {
                        print("Erro ao salvar nome do grupo: \(saveError.localizedDescription)")
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
    @objc func copyButtonTapped() {
        print("Copy button tapped")
        copyCodeLabel.isHidden = true
        codeCopiedLabel.isHidden = false
        
        UIPasteboard.general.string = copyCodeLabel.text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.copyCodeLabel.isHidden = false
            self?.codeCopiedLabel.isHidden = true
        }
    }
    
    @objc func editPrizeTapped() {
        let alert = UIAlertController(title: "Edit Prize", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.prizeLabel.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let newPrize = alert.textFields?.first?.text,
                  let groupID = self.groupModel?.id else { return }

            self.prizeLabel.text = newPrize

            CKContainer.default().publicCloudDatabase.fetch(withRecordID: groupID) { record, error in
                guard let record = record, error == nil else {
                    print("Erro ao buscar grupo: \(error?.localizedDescription ?? "Desconhecido")")
                    return
                }

                record["prize"] = newPrize
                CKContainer.default().publicCloudDatabase.save(record) { _, saveError in
                    if let saveError = saveError {
                        print("Erro ao salvar prêmio: \(saveError.localizedDescription)")
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
    func updateLayout() {
        usersTableView.removeFromSuperview()
        addSubviews()
        setupConstraints()
        usersTableView.reloadData()
    }
    
    func loadMembers(for group: Group) {
        self.members = group.users.map { user in
            let image = user.avatarHead ?? UIImage(named: "defaultImage")
            return (user.recordID.recordName, user.nickname, image)
        }
        self.usersTableView.reloadData()
    }
}

extension GroupDetailsViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(groupImage)
        view.addSubview(mainStackView)
        view.addSubview(prizeStackView)
        view.addSubview(tableViewHeader)
        view.addSubview(usersTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Header View
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // Mais Stack
            
            groupImage.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 13),
            groupImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 111),
            groupImage.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -111),

            mainStackView.topAnchor.constraint(equalTo: groupImage.bottomAnchor, constant: 13),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupImage.widthAnchor.constraint(equalToConstant: 171),
            groupImage.heightAnchor.constraint(equalToConstant: 173),
            
            prizeStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 32),
            prizeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            prizeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            
            trophyImage.widthAnchor.constraint(equalToConstant: 18),
            trophyImage.heightAnchor.constraint(equalToConstant: 18),
            
            // TableView
            
            tableViewHeader.topAnchor.constraint(equalTo: prizeStackView.bottomAnchor, constant: 40),
            tableViewHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            usersTableView.topAnchor.constraint(equalTo: tableViewHeader.bottomAnchor, constant: 5),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension GroupDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailsTableViewCell", for: indexPath) as? GroupDetailsTableViewCell else {
            return UITableViewCell()
        }
        let member = members[indexPath.row]
        cell.userLabel.text = member.nickname
        cell.userImage.image = member.image
        cell.deleteButton.isHidden = !self.isCurrentUserCreator
        cell.deleteAction = { [weak self] in
            guard let self = self,
                  let groupID = self.groupModel?.id,
                  let groupName = self.groupModel?.name else { return }

            let memberIDString = member.id
            let memberNickname = member.nickname

            let alert = UIAlertController(
                title: nil,
                message: "Remove \(memberNickname) from the \"\(groupName)\" group?",
                preferredStyle: .actionSheet
            )

            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: groupID) { record, error in
                    if let error = error {
                        print("Erro ao buscar grupo: \(error.localizedDescription)")
                        return
                    }

                    guard let record = record,
                          var memberIDs = record["members"] as? [String] else {
                        print("Campo 'members' não encontrado ou inválido.")
                        return
                    }

                    memberIDs.removeAll { $0 == memberIDString }
                    record["members"] = memberIDs

                    CKContainer.default().publicCloudDatabase.save(record) { _, saveError in
                        if let saveError = saveError {
                            print("Erro ao salvar grupo: \(saveError.localizedDescription)")
                            return
                        }

                        DispatchQueue.main.async {
                            self.members.remove(at: indexPath.row)
                            self.usersTableView.performBatchUpdates({
                                self.usersTableView.deleteRows(at: [indexPath], with: .none)
                            }, completion: { _ in
                                self.usersTableView.reloadData()
                            })
                        }
                    }
                }
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
        
        return cell
    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let memberRecord = members[indexPath.row]
//            CKContainer.default().publicCloudDatabase.delete(withRecordID: memberRecord.recordID) { [weak self] recordID, error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Erro ao remover membro: \(error.localizedDescription)")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.members.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                }
//            }
//        }
//    }
}


extension GroupDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerLabel = UILabel()
//        headerLabel.text = "Members"
//        headerLabel.font = UIFont(name: "Jersey10-Regular", size: 24)
//        headerLabel.textColor = .label
//        headerLabel.textAlignment = .left
//        headerLabel.backgroundColor = .clear
//
//        let containerView = UIView()
//        containerView.addSubview(headerLabel)
//        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
//            headerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
//        ])
//
//        return containerView
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
