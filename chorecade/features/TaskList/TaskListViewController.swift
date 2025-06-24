//
//  TaskListViewController.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 16/06/25.
//

import UIKit

class TaskListViewController: UIViewController {
    // MARK: - View
    lazy var taskListView: TaskListView = {
        let view = TaskListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onAddTaskButtonTaped = handleTap
        return view
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        taskListView.onTaskSelected = { [weak self] task in
            let detailsVC = TaskDetailsViewController()
            detailsVC.task = task
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func handleTap() {
        let modalViewController = AddNewTaskModalViewController()
        
        modalViewController.modalPresentationStyle = .pageSheet
        modalViewController.delegate = taskListView
        modalViewController.selectedGroup = taskListView.currentSelectedGroup
        
        if let sheet = modalViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        present(modalViewController, animated: true)
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
