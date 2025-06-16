//
//  TaskListTableViewCell.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 16/06/25.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    // MARK: Reuse ID
    static let reuseIdentifier = "taskList-cell"
    
    // MARK: - Components
    var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let taskSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pointsBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemPurple
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.primaryPurple100
        layer.borderWidth = 1
        layer.borderColor = UIColor.primaryPurple300.cgColor
        layer.cornerRadius = 16
        
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskListTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        addSubview(taskTitleLabel)
        addSubview(taskSubtitleLabel)
        addSubview(pointsBadge)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskTitleLabel.trailingAnchor.constraint(equalTo: pointsBadge.leadingAnchor, constant: -8),
            
            taskSubtitleLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 4),
            taskSubtitleLabel.leadingAnchor.constraint(equalTo: taskTitleLabel.leadingAnchor),
            taskSubtitleLabel.trailingAnchor.constraint(equalTo: taskTitleLabel.trailingAnchor),
            taskSubtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            pointsBadge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pointsBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pointsBadge.widthAnchor.constraint(equalToConstant: 40),
            pointsBadge.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
