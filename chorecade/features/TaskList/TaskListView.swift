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
    
    lazy var addNewTaskButton = Components.getButton(content: "Add a new Task +", action: #selector(handleTap), target: self)
    
    lazy var taskLabel = Components.getLabel(content: "Recent Tasks", font: Fonts.taskDetails)
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "taskList-cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Closure
    var onAddTaskButtonTaped: (() -> Void)?
    
    // MARK: - Mocks
    private let mockTitles: [String] = ["Clean litter box / pick up poop", "Brush pet’s fur", "Full house cleaning"]
    private let mockDescriptions: [String] = ["Collected and Cleaned the floor", "I brushed Joaquim", "Cleaned all places in the house"]
    private let mockUsers: [String] = ["Julian", "Bibi18", "JujuJBah"]
    
    // MARK: - Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setup()
    }
     
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    var action: () -> Void = {}
    
    @objc func handleTap() {
        action()
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
        
        let title = mockTitles[indexPath.row]
        let description = mockDescriptions[indexPath.row]
        let user = mockUsers[indexPath.row]
        
        cell.taskTitleLabel.text = title
        cell.taskDescriptionLabel.text = description
        cell.taskPointsLabel.text = "+10 points"
        cell.nameUserLabel.text = user
        
        return cell
    }
}

extension TaskListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}
