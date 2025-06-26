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
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var pointsLabel = Components.getLabel(content: "", font: Fonts.points, alignment: .center)
    
    lazy var pointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.layer.cornerRadius = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        return stackView
    }()
    
    private lazy var mainStack: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, spacer, pointsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
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
            
            pointsStack.heightAnchor.constraint(equalToConstant: 26),
            
        ])
    }
}


