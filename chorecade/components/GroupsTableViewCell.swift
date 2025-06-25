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
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        pointsStack.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.alignment = .center
        return stackView
    }()
    
    // User info
    
    lazy var userImagesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = -15
        stack.alignment = .center
        return stack
    }()
    
    // Popula o stack com imagens dos usuários
    func configure(with users: [User]) {
        userImagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for user in users {
            let image = user.avatarHead ?? UIImage(named: "defaultImage")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 21
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
            userImagesStackView.addArrangedSubview(imageView)
        }
    }

    lazy var groupStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupTitleLabel, userImagesStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return stackView
    }()
    
    lazy var mainsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupStack, groupPointsSatckView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 38
    
        return stackView
    }()
    
    // Cell Stack
    
    lazy var cellStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [groupImage, mainsStack])
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
        contentView.addSubview(cellStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cellStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            groupImage.widthAnchor.constraint(equalToConstant: 75),
            groupImage.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}
