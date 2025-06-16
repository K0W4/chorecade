//
//  AddNewTaskModalViewController.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 16/06/25.
//

import UIKit

class AddNewTaskModalViewController: UIViewController {
    
    // MARK: Views
    
    lazy var categoryButton = Components.getButton(
        content: "Category",
        action: #selector(handleCategoryButton),
    )
    
    lazy var titleField = Components.getLabel(content: "Add Description")
    
    lazy var descriptionField = Components.getTextField(
        placeholder: "Ex: Cleaned the airfryer too"
    )
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryButton, titleField, descriptionField])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setup()
    }
    
    // MARK: Functions
    
    @objc func handleCategoryButton() {
        print("category button tapped")
    }
    
}

extension AddNewTaskModalViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    
}
