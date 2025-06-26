//
//  ModalCreateGroupViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 21/06/25.
//

import UIKit
import CloudKit

protocol ModalCreateGroupDelegate: AnyObject {
    func didCreateGroup()
}

class ModalCreateGroupViewController: UIViewController {
    
    // MARK: Variables
    var activePhotoComponent: PhotoComponent?
    let colorOptions: [UIColor] = [.selectionRed, .selectionOrange, .selectionYellow, .selectionGreen, .selectionBlue, .selectionPurple]
    var colorButtons: [UIButton] = []
    var selectedColorIndex: Int? = nil
    weak var delegate: ModalCreateGroupDelegate?
    
    // MARK: Components
    private lazy var headerView: ModalHeader = {
        var header = ModalHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Create Group"
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    private lazy var addGroupPhoto: PhotoComponent = {
        var photo = PhotoComponent()
        photo.viewController = self
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Name:"
        label.textColor = .black
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = Components.getTextField(placeholder: "Ex: My Family")
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()
    
    private lazy var rewardLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Reward:"
        label.textColor = .black
        return label
    }()
    
    private lazy var rewardTextField: UITextField = {
        let textField = Components.getTextField(placeholder: "Ex: Dinner at McDonald's")
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    private lazy var rewardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rewardLabel, rewardTextField])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        rewardTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rewardTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            rewardTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()
    
    private lazy var colorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Color:"
        label.textColor = .black
        return label
    }()
    
    private lazy var coloredButtonsStackView: UIStackView = {
        colorButtons = colorOptions.enumerated().map { (index, color) in
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = color
            button.layer.cornerRadius = 21
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 42),
                button.heightAnchor.constraint(equalToConstant: 42)
            ])
            return button
        }

        let colorStackView = UIStackView(arrangedSubviews: colorButtons)
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.axis = .horizontal
        colorStackView.spacing = 10
        colorStackView.alignment = .center
        return colorStackView
    }()
    
    private lazy var colorsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coloredButtonsStackView)

        NSLayoutConstraint.activate([
            coloredButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29.5),
            coloredButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29.5),
            coloredButtonsStackView.topAnchor.constraint(equalTo: view.topAnchor),
            coloredButtonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }()
        
    private lazy var colorsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [colorLabel, colorsContainerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var periodLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .left
        label.text = "Competition period (when the prize is calculated):"
        label.textColor = .black
        return label
    }()
    
    private lazy var monthlyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)

        button.backgroundColor = .primaryPurple100
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Jersey10-Regular", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Monthly", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 16

        return button
    }()
    
    private lazy var weeklyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)

        button.backgroundColor = .primaryPurple100
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Jersey10-Regular", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Weekly", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 16

        return button
    }()
    
    private lazy var biweeklyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)

        button.backgroundColor = .primaryPurple100
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Jersey10-Regular", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Biweekly", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 16

        return button
    }()
    
    private var filterButtons: [UIButton] {
        return [monthlyButton, weeklyButton, biweeklyButton]
    }
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [monthlyButton, weeklyButton, biweeklyButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            buttonStackView.topAnchor.constraint(equalTo: view.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }()
    
    private lazy var labelButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [periodLabel, buttonContainerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameStackView, rewardStackView, colorsStackView, labelButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()
    
    // MARK: Button functions
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        selectedColorIndex = sender.tag

        for (index, button) in colorButtons.enumerated() {
            if index == selectedColorIndex {
                button.alpha = 1.0
            } else {
                button.alpha = 0.3
            }
        }
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        for button in filterButtons {
            button.backgroundColor = .primaryPurple100
        }

        sender.backgroundColor = .primaryPurple300
    }

    // MARK: Proprieties
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setup()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        addGroupPhoto.onPhotoRequest = { [weak self] in
            self?.activePhotoComponent = self?.addGroupPhoto
        }
    }
    
    // MARK: Functions
    @objc func addButtonTapped() {
        let groupName = nameTextField.text ?? ""
        let prize = rewardTextField.text ?? ""
        
        Task {
            do {
                let groupCode = try await createGroup(groupName: groupName, prize: prize)
                print("Your group code is: \(groupCode)")
                self.delegate?.didCreateGroup()
                self.dismiss(animated: true)
            } catch {
                print("Error creating group: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to create group: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.view.tintColor = UIColor.primaryPurple300
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }        
    }
}

extension ModalCreateGroupViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(addGroupPhoto)
        view.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Header View
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // Add Group Photo
            
            addGroupPhoto.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            addGroupPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 111),
            addGroupPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -111),
            addGroupPhoto.heightAnchor.constraint(equalToConstant: 171),
            
            // Main Stack
            
            mainStackView.topAnchor.constraint(equalTo: addGroupPhoto.bottomAnchor, constant: 32),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
}

extension ModalCreateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        activePhotoComponent?.selectedImage = image
    }
}

extension ModalCreateGroupViewController {
    
    // MARK: Create group
    func createGroup(groupName: String, prize: String) async throws -> String {
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
        
        if let selectedImage = addGroupPhoto.selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            let tempDirectory = FileManager.default.temporaryDirectory
            let imageURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            try imageData.write(to: imageURL)
            let asset = CKAsset(fileURL: imageURL)
            groupRecord["groupImage"] = asset
        } else {
            if let bundleImage = UIImage(named: "defaultImage"),
               let data = bundleImage.jpegData(compressionQuality: 0.8) {
                
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("defaultGroupImage.jpg")
                try? data.write(to: tempURL)
                groupRecord["groupImage"] = CKAsset(fileURL: tempURL)
            }
        }
        
        groupRecord["name"] = groupName as NSString
        groupRecord["startDate"] = Date() as NSDate
        groupRecord["duration"] = 1 as NSNumber
        groupRecord["groupCode"] = groupCode as NSString
        groupRecord["members"] = [userIDString] as NSArray
        groupRecord["prize"] = prize as NSString
        groupRecord["createdBy"] = String(describing: Repository.userRecordID?.recordName ?? String()) as NSString
        
        CreateGroupViewController.addGroupCodeTo(user: userIDString, code: groupCode)

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
}
