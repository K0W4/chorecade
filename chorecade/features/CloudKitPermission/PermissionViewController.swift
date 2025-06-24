//
//  PermissionViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 20/06/25.
//

import Foundation
import UIKit
import CloudKit

class PermissionViewController: UIViewController {
    
    // iCloud label
    lazy var statusLabel = Components.getLabel(content: "", fontSize: 30, textColor: .red)
    lazy var nameLabel = Components.getLabel(content: "", textColor: .red)
    lazy var permissionLabel = Components.getLabel(content: "", textColor: .red)
    
    // Permission stack
    lazy var permissionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusLabel, nameLabel, permissionLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    // Error label
    lazy var errorLabel = Components.getLabel(content: "", textColor: .cyan)
    
    // Button
    lazy var button = Components.getButton(content: "Proceed", action: #selector(handleButton), backgroundColor: .systemPink)
    
    // MARK: Properties
    var isSignedIniCloud: Bool = false
    var hasPermission: Bool = false
    var canProceed: Bool = false
    
    
    // MARK: Scene
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        getiCloudStatus()
        requestPermission()

        setup()
    }
    
    
    // MARK: Button functions
    @objc func handleButton() {
        print("button tapped")
        
        if !canProceed {
            checkCanProceed()
            
            if !canProceed {
                return
            }
        }
        
        let vc = CreateGroupViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc, animated: false)
    }
    
    // MARK: Functions
    private func checkCanProceed() {
        if !isSignedIniCloud {
            errorLabel.text = "You need to sign in to iCloud"
            return
        }
        
        if !hasPermission {
            errorLabel.text = "You need to grant permission to access your iCloud"
            return
        }
        
        errorLabel.text = "Able to proceed"
        
        canProceed = true
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async { [self] in
                
                switch status {
                case .available:
                    self.isSignedIniCloud = true
                    self.statusLabel.text = "Available"
                    break
                    
                case .noAccount:
                    statusLabel.text = "No iCloud account"
                    break
                    
                case .couldNotDetermine:
                    statusLabel.text = "Could not determine"
                    break
                    
                case .restricted:
                    statusLabel.text = "Restricted"
                    break
                    
                default:
                    statusLabel.text = "Unknown"
                    break
                }
            }
        }
    }
    
    private func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] status, error in
            DispatchQueue.main.async {
                if status == .granted {
                    self?.permissionLabel.text = "Permission granted"
                    self?.hasPermission = true
                } else {
                    self?.permissionLabel.text = "Permission denied"
                }
                self?.checkCanProceed()
            }
        }
    }
    

}


// MARK: View Code Protocol
extension PermissionViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(permissionStack)
        view.addSubview(errorLabel)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            // Permission stack
            permissionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            permissionStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Button
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Error label
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -8)
        ])
    }
}
    

