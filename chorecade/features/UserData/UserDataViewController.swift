//
//  UserDataViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 23/06/25.
//

import UIKit
import Foundation
import CloudKit

class UserDataViewController: UIViewController {
    
    var avatarImage: UIImage?
    
    // MARK: - Components
    
    lazy var avatarImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 48)
        label.textAlignment = .center
        label.text = "Welcome!"
        label.textColor = .black
        return label
    }()
    
    private lazy var doneButton = Components.getButton(
        content: "Done",
        action: #selector(handleSaveButton),
        font: UIFont(name: "Jersey10-Regular", size: 24),
        size: 40
    )
    
    
    private lazy var nicknameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Nickname"
        label.textColor = .black
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = Components.getTextField(placeholder: "Ex: My nickname")
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nicknameLabel, nicknameTextField, doneButton])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
        ])
        return stackView
    }()
    
    init(avatarImage: UIImage?) {
        self.avatarImage = avatarImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setup()
        
        let tapDismissKeyboard = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tapDismissKeyboard)
        
        avatarImageView.image = avatarImage
        
        CKContainer.default().accountStatus { status, error in
            print("Account status:", status.rawValue)
            DispatchQueue.main.async {
                if status != .available {
                    let alert = UIAlertController(
                        title: "iCloud not available",
                        message: "You need to be logged in to iCloud to continue.",
                        preferredStyle: .alert
                    )
                    alert.view.tintColor = UIColor.primaryPurple300
                    alert.addAction(UIAlertAction(title: "Close", style: .destructive) { _ in
                        exit(0)
                    })
                    self.present(alert, animated: true)
                    return
                }
                self.requestCloudPermission { granted in
                    if !granted {
                        let alert = UIAlertController(
                            title: "Permission denied",
                            message: "You need to allow this app to access your iCloud to continue.",
                            preferredStyle: .alert
                        )
                        alert.view.tintColor = UIColor.primaryPurple300
                        alert.addAction(UIAlertAction(title: "Close", style: .destructive) { _ in
                            exit(0)
                        })
                        self.present(alert, animated: true)
                    } else {
                        // Só busca userID e carrega grupos se permissão concedida!
                        Task {
                            let recordID = await Repository.fetchiCloudUserRecordID()
                            if recordID != nil {
                                self.setup()
                            } else {
                                print("Erro: não conseguiu obter o userRecordID")
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    @objc func handleSaveButton() {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            // Mostra um alerta se o campo estiver vazio
            let alert = UIAlertController(title: "Attention", message: "Type a nickname!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        Repository.updateUserNickname(nickname) { sucesso in
            DispatchQueue.main.async {
                if sucesso {
                    // Exemplo: feedback visual ou navegação
                    let alert = UIAlertController(title: "Success", message: "Avatar created, welcome!", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.primaryPurple300
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        // Troca a root para o TabBarController ao clicar em OK
                        if let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate {
                            sceneDelegate.changeRootViewController(TabBarController())
                        }
                    })
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Could not save the nickname.", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.primaryPurple300
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func requestCloudPermission(completion: @escaping (Bool) -> Void) {
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
}

// MARK: Extensions
extension UserDataViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(avatarImageView)
        view.addSubview(textFieldStackView)
        view.addSubview(doneButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nicknameTextField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 200),
            avatarImageView.heightAnchor.constraint(equalToConstant: 260),
            
            textFieldStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 20),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
}
