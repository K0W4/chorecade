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
    
    // Task
    
    lazy var taskTitleLabel = Components.getLabel(content: "", font: Fonts.titleConcludedTask)
    
    lazy var taskDescriptionLabel = Components.getLabel(content: "", font: Fonts.descriptionTask)
    
    lazy var taskLabelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskTitleLabel, taskDescriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var taskImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.primaryPurple300.cgColor
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Top Stack

    lazy var topStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskImage, taskLabelsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    // Points
    
    lazy var taskPointsLabel = Components.getLabel(content: "", font: Fonts.points, alignment: .center)
    
    lazy var taskPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
    
    // User info
    
    lazy var nameUserLabel = Components.getLabel(content: "", font: Fonts.taskDetails, textColor: .systemGray2, alignment: .right)
    
    lazy var iconUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 13
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var userInfosStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameUserLabel, iconUserImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()
    
    // Bottom Stack
    
    lazy var bottomStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskPointsStack, userInfosStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // Cell Stack
    
    lazy var cellStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStack, bottomStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.primaryPurple100
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.primaryPurple300.cgColor
        stackView.layer.cornerRadius = 16
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
        
        taskTitleLabel.numberOfLines = 2
        taskTitleLabel.lineBreakMode = .byWordWrapping
//        
//        taskDescriptionLabel.numberOfLines = 2
//        taskDescriptionLabel.lineBreakMode = .byWordWrapping
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskListTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        addSubview(cellStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStack.topAnchor.constraint(equalTo: topAnchor),
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            taskPointsStack.heightAnchor.constraint(equalToConstant: 26),
            
            taskImage.widthAnchor.constraint(equalToConstant: 45),
            taskImage.heightAnchor.constraint(equalToConstant: 45),
            
            iconUserImage.widthAnchor.constraint(equalToConstant: 28),
        ])
    }
}
