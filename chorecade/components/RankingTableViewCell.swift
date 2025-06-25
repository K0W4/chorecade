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
    lazy var userNameLabel = Components.getLabel(content: "", font: Fonts.taskDetails, alignment: .left)
    
    lazy var userPointsLabel = Components.getLabel(content: "", font: Fonts.points, alignment: .center)
    
    lazy var userPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
        
    lazy var userInfoStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userPointsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
        
    lazy var userPosition = Components.getLabel(content: "", font: Fonts.taskDetails, alignment: .left)
    
    lazy var userPositionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userPosition])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.primaryPurple300.cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var userDetailsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userInfoStack, userPositionStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 104
        return stackView
    }()
    
    lazy var userIconImage: UIImageView = {
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
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        self.selectedBackgroundView = bgColorView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RankingTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        addSubview(cellStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStack.topAnchor.constraint(equalTo: topAnchor),
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
//            taskPointsStack.heightAnchor.constraint(equalToConstant: 26),
//            
//            taskImage.widthAnchor.constraint(equalToConstant: 45),
//            taskImage.heightAnchor.constraint(equalToConstant: 45),
//            
//            iconUserImage.widthAnchor.constraint(equalToConstant: 28),
        ])
    }
}
