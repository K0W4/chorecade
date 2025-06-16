//
//  ViewController.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 06/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var oie = Components.getButton(content: "Add New Task +", action: #selector(handleOie))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func handleOie() {
        present(AddNewTaskModalViewController(), animated: true)
    }
}

extension ViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(oie)
        view.backgroundColor = .background
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            oie.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            oie.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            oie.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    
}
