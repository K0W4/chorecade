//
//  GroupDetailsTableViewCell.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 24/06/25.
//

import UIKit
import CloudKit

class GroupDetailsTableViewCell: UITableViewCell {
    
    // MARK: Reusable identifier
    static let reuseIdentifier = "GroupDetailsTableViewCell"
    
    // MARK: - Components
    
    // Group
    
    lazy var userLabel = Components.getLabel(content: "", font: Fonts.titleConcludedTask, alignment: .left)
    
    lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    lazy var userStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userImage, userLabel, deleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
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
        
        userLabel.setContentHuggingPriority(.required, for: .horizontal)
        userLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        userLabel.numberOfLines = 1
        userLabel.lineBreakMode = .byTruncatingTail
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupDetailsTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(userStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            userImage.widthAnchor.constraint(equalToConstant: 75),
            userImage.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
