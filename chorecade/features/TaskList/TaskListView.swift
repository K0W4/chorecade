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
    
    lazy var tasksStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskLabel, tasksTableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var emptyStateLabel = Components.getLabel(content: "Click on “add a new task” to add a new task", font: Fonts.nameTasksCategories, textColor: .systemGray2)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(addNewTaskButton)
        contentView.addSubview(tasksStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            addNewTaskButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 320),
            addNewTaskButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addNewTaskButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tasksTableView.heightAnchor.constraint(equalToConstant: CGFloat(3 * 136 + 32)),
            
            tasksStack.topAnchor.constraint(equalTo: addNewTaskButton.bottomAnchor, constant: 24),
            tasksStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tasksStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tasksStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        emptyView.isHidden = !sections.isEmpty
//        tableView.isHidden = sections.isEmpty
//        return sections.count
//    }
}

extension TaskListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}
