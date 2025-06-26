//
//  RankingTableViewCell.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 18/06/25.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    // MARK: Reuse ID
    static let reuseIdentifier = "ranking-cell"
    
    // MARK: - Components
    lazy var userNameLabel = Components.getLabel(content: "morte", font: Fonts.taskDetails, alignment: .left)
    
    lazy var userPointsLabel = Components.getLabel(content: "15 points", font: Fonts.points, alignment: .center)
    
    lazy var userPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .yellowPoints
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
    
    lazy var userInfoStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userPointsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var userPosition = Components.getLabel(
        content: "3",
        font: Fonts.taskDetails,
        alignment: .center
    )
    
    lazy var userPositionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userPosition])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 15
        stackView.layer.borderColor = UIColor.primaryPurple300.cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()
    
    lazy var userDetailsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userInfoStack, userPositionStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var userIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "fem1-head")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.namedColors.randomElement()?.value
        imageView.layer.cornerRadius = 37.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var userStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userIconImage, userDetailsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 24
        return stackView
    }()
    
    lazy var cellStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.background
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
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        self.selectedBackgroundView = bgColorView
        userInfoStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        userPositionStack.setContentHuggingPriority(.required, for: .horizontal)
        
        userInfoStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        userPositionStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, points: Int, position: Int, avatar: UIImage) {
        userNameLabel.text = name
        userPointsLabel.text = "+\(points) points"
        userIconImage.image = avatar
        userPosition.text = "\(position)"
    }
}

extension RankingTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        addSubview(cellStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            userIconImage.widthAnchor.constraint(equalToConstant: 75),
            userIconImage.heightAnchor.constraint(equalToConstant: 75),
            
            
            
            userPositionStack.widthAnchor.constraint(equalToConstant: 30),
            userPositionStack.heightAnchor.constraint(equalToConstant: 30),
            
            
        ])
    }
}
