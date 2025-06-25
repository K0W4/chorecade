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
    
    
    // MARK: Scene
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setup()
        
        
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
                    
                    alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
                        Task {
                            let recordID = await Repository.fetchiCloudUserRecordID()
                            if let recordID = recordID {
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
    
}


// MARK: View Code Protocol
extension PermissionViewController: ViewCodeProtocol {
    func addSubviews() {
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
        ])
    }
}


