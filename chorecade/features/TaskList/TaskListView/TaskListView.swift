//
//  TaskListView.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 16/06/25.
//

import UIKit

class TaskListView: UIView {
    
    // MARK: Variables
    
    var currentSelectedGroup: Group?
    
    
    // MARK: - Components
    
    lazy var avatarUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var addNewTaskButton = Components.getButton(content: "Add a new Task +", action: #selector(handleTap))
    
    lazy var groupSelector: GroupSelector = {
        let groupSelector = GroupSelector()
        groupSelector.onGroupSelected = { [weak self] selectedGroup in
            guard let self = self else { return } // Ensure self is still around
            
            // Update the stored currentSelectedGroup
            self.currentSelectedGroup = selectedGroup
            print("DEBUG: Group selector notified new group: \(selectedGroup.name)")
            
            // Fetch tasks for the newly selected group and reload
            self.tasksByGroup = Persistence.getTasks(for: selectedGroup.id)
            print("DEBUG: Fetched \(self.tasksByGroup.count) tasks for \(selectedGroup.name)")
            self.tasksTableView.reloadData()
        }
        return groupSelector
    }()
    
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "taskList-cell")
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: "empty-list-cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        return tableView
    }()
    
    lazy var tasksStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:  [groupSelector, tasksTableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
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
    
    var tasksByGroup: [Task] = []
    
    
    // MARK: - Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setup()
        
      
        
        // Initialize currentSelectedGroup from groupSelector
        self.currentSelectedGroup = groupSelector.selectedGroup
        self.tasksByGroup = Persistence.getTasks(for: currentSelectedGroup?.id ?? UUID())
        
        // Update currentSelectedGroup when group changes
//        groupSelector.onGroupSelected = { [weak self] selected in
//            print("Tasks for selected group: \(selected.tasks)")
//            self?.currentSelectedGroup = selected // Update the currentSelectedGroup
//            self?.tasksByGroup = Persistence.getTasks(for: selected.id) // Fetch tasks for the new group
//            self?.tasksTableView.reloadData()
//        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    @objc func handleTap() {
        onAddTaskButtonTaped?()
    }
    
    // funcao para definir o tamanho da tableView
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            tasksTableView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    tasksTableView.removeConstraint(constraint)
                }
            }
            
            let heightConstraint = tasksTableView.heightAnchor.constraint(equalToConstant: tasksTableView.contentSize.height)
            heightConstraint.isActive = true
            layoutIfNeeded()
        }
    }
    
    deinit {
        tasksTableView.removeObserver(self, forKeyPath: "contentSize")
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
            
            tasksStack.topAnchor.constraint(equalTo: addNewTaskButton.bottomAnchor, constant: 24),
            tasksStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tasksStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tasksStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            
        ])
    }
}

extension TaskListView: AddNewTaskModalDelegate {
    
    func didAddTask(task: Task) {
        if let selectedGroupId = self.currentSelectedGroup?.id {
            self.tasksByGroup = Persistence.getTasks(for: selectedGroupId)
            print("DEBUG: Task added. Reloading tasks for group ID: \(selectedGroupId). New count: \(self.tasksByGroup.count)")
            self.tasksTableView.reloadData()
        } else {
            print("DEBUG: No group selected in TaskListView, cannot refresh after adding task.")
        }
        
    }
    
}
