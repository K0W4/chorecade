//
//  UserDataViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 23/06/25.
//

import UIKit
import Foundation

class UserDataViewController: UIViewController {
    
    // MARK: - Components
    private lazy var groupLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 48)
        label.textAlignment = .center
        label.text = "Insert your data"
        label.textColor = .black
        return label
    }()
    
    private lazy var createGroupButton = Components.getButton(content: " Save Data + ", action: #selector(handleSaveButton), font: UIFont(name: "Jersey10-Regular", size: 24))
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupLabel, createGroupButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Your nickname:"
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
        let stackView = UIStackView(arrangedSubviews: [nicknameLabel, nicknameTextField])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setup()
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
                    let alert = UIAlertController(title: "Success", message: "Nickname saved!", preferredStyle: .alert)
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
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

// MARK: Extensions
extension UserDataViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(topStackView)
        view.addSubview(textFieldStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textFieldStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 40),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
