//
//  TaskDetailsViewController.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    // MARK: - View
    lazy var taskDetailsView: TaskDetailsView = {
        let view = TaskDetailsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Extensions
extension TaskDetailsViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(taskDetailsView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            taskDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
