//
//  GroupsTableViewCell.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 21/06/25.
//

import UIKit
import CloudKit

class GroupsTableViewCell: UITableViewCell {
    
    // MARK: Reusable identifier
    static let reuseIdentifier = "GroupsTableViewCell"
    
    // MARK: - Components
    
    // Group
//    
//    lazy var groupTitleLabel = Components.getLabel(content: "", font: Fonts.titleConcludedTask, alignment: .left)
    
    lazy var groupTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .label
//        label.lineBreakMode = .byTruncatingTail
        
        label.font = Fonts.titleConcludedTask
        return label
    }()
    
    lazy var groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    // Points
    
    lazy var groupPointsLabel = Components.getLabel(content: "Total Points: ", font: Fonts.points)
    
    lazy var groupPointsInternalLabel = Components.getLabel(content: "97 pt", font: Fonts.points, alignment: .center)
    
    lazy var pointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupPointsInternalLabel])
        groupPointsInternalLabel.numberOfLines = 2
        groupPointsInternalLabel.lineBreakMode = .byWordWrapping
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 13
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
    
    lazy var groupPointsSatckView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupPointsLabel, pointsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        stackView.distribution = .fill
        
        pointsStack.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return stackView
    }()
    
    // User info
    
    lazy var userImagesStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = -15
        return stack
    }()
    
    // Popula o stack com imagens dos usuários
    func configure(with users: [User]) {
        userImagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for user in users {
            let image = user.profilePicture ?? UIImage(named: "defaultImage")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 18
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
            userImagesStackView.addArrangedSubview(imageView)
           
        }
        
    }

    lazy var groupStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupTitleLabel, userImagesStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 8
        stackView.alignment = .leading
        
        
        return stackView
    }()
    
    lazy var mainsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupStack, groupPointsSatckView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.distribution = .fill
//        stackView.spacing = 38
    
        return stackView
    }()
    
    // Cell Stack
    
    lazy var cellStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupImage, groupStack, groupPointsSatckView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.selectionPurple
        stackView.layer.cornerRadius = 16
        stackView.distribution = .fill
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        
//        mainsStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        mainsStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return stackView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        self.selectedBackgroundView = bgColorView
        
        groupTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        groupTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        groupTitleLabel.numberOfLines = 1
        groupTitleLabel.lineBreakMode = .byTruncatingTail
        groupPointsSatckView.setContentHuggingPriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupsTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.backgroundColor = UIColor.selectionPurple
        contentView.layer.cornerRadius = 16
        contentView.addSubview(groupImage)
        contentView.addSubview(groupStack)
        contentView.addSubview(groupPointsSatckView)
//        contentView.addSubview(main)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            groupImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            groupImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            groupImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            groupImage.widthAnchor.constraint(equalToConstant: 75),
            groupImage.heightAnchor.constraint(equalToConstant: 76),
            
            
            groupStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            groupStack.leadingAnchor.constraint(equalTo: groupImage.trailingAnchor, constant: 16),
            groupStack.trailingAnchor.constraint(equalTo: groupPointsSatckView.leadingAnchor, constant: -16),
            
            
            groupPointsSatckView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            groupPointsSatckView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            groupPointsSatckView.widthAnchor.constraint(equalToConstant: 76),
            
        ])
    }
}
