//
//  TaskListView.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 16/06/25.
//

import UIKit

class TaskListView: UIView {
    // MARK: - Components
    lazy var avatarUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var addNewTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New Task", for: .normal)
        return button
    }()
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Tasks"
        label.textAlignment = .center
        return label
    }()
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
}

// MARK: - Extensions
extension TaskListView: ViewCodeProtocol {
    func addSubviews() {
        <#code#>
    }
    
    func setupConstraints() {
        <#code#>
    }
}
