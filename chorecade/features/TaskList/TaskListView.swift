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
    
    lazy var addNewTaskButton = Components.getButton(content: "Add a new task +", action: #selector(TaskListViewController.handleTap), target: self)
    
    lazy var taskLabel = Components.getLabel(content: "Recent Tasks", font: Fonts.taskDetails)
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "taskList-cell")
        tableView.dataSource = self
        tableView.backgroundColor = .red
        return tableView
    }()
    
    // MARK: - Closure
    var onAddTaskButtonTaped: (() -> Void)?
    
    private let mockTasks: [Task] = [
        Task(title: "Lavar a louça", description: "Usar sabão neutro", type: [.cleaning], level: 1),
        Task(title: "Varrer a casa", description: "Não esquecer os cantos!", type: [.cleaning], level: 2),
        Task(title: "Tirar o lixo", description: "Levar o saco para fora", type: [.cleaning], level: 1)
    ]
    
    // MARK: - Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setup()
    }
     
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

// MARK: - Extensions
extension TaskListView: ViewCodeProtocol {
    func addSubviews() {
        addSubview(addNewTaskButton)
        addSubview(taskLabel)
        addSubview(tasksTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addNewTaskButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 320),
            addNewTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addNewTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            taskLabel.topAnchor.constraint(equalTo: addNewTaskButton.bottomAnchor, constant: 24),
            taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            tasksTableView.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 16),
            tasksTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tasksTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tasksTableView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

extension TaskListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskList-cell", for: indexPath) as? TaskListTableViewCell else {
            return UITableViewCell()
        }
        
        let mock = mockTasks[indexPath.row]
        cell.taskTitleLabel.text = mock.title
        cell.taskSubtitleLabel.text = mock.description
        cell.pointsBadge.text = "10"
        
        return cell
    }
}
