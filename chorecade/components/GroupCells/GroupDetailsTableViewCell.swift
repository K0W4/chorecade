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
    
    lazy var userLabel = Components.getLabel(content: "User", font: Fonts.titleConcludedTask, alignment: .left)
    
    lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 37.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "minus.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        button.tintColor = .systemRed
        return button
    }()

    lazy var userStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userImage, userLabel, deleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.setCustomSpacing(20, after: userImage)
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 25)
        stackView.isLayoutMarginsRelativeArrangement = true
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
        
        userLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        userLabel.numberOfLines = 1
        userLabel.lineBreakMode = .byTruncatingTail
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    @objc func deleteUser() {
        print("deleteUser")
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
