//
//  CollectionViewListCell.swift
//  farm.fi-app
//
//  Created by júlia fazenda ruiz on 26/05/25.
//


import UIKit

class CategoryCollectionViewListCell: UICollectionViewListCell {
    
    // MARK: Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.nameTasksCategories
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()
    
    
    private lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.points
        label.textColor = .black
        label.backgroundColor = .yellowPoints
        label.layer.cornerRadius = 16
        label.textAlignment = .right
        return label
    }()
    
    
    private lazy var mainStack: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, spacer, pointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: Properties
    static let identifier: String = "listCollectionCell"
    
    // MARK: Functions
    func configure(title: String, points: Int) {
        titleLabel.text = title
        pointsLabel.text = "+\(points) points"
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        contentView.backgroundColor = .primaryPurple100
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: ViewCodeProtocol
extension CategoryCollectionViewListCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(mainStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
        ])
    }
}


