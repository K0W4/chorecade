//
//  TaskListViewController.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 16/06/25.
//

import UIKit

class TaskListViewController: UIViewController {
    // MARK: - View
    private lazy var taskListView: TaskListView = {
        let view = TaskListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    @objc func handleTap() {
        print("TAP")
    }
}

// MARK: - Extensions
extension TaskListViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(taskListView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskListView.topAnchor.constraint(equalTo: view.topAnchor),
            taskListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
