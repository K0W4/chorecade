//
//  CollectionViewListHeader.swift
//  farm.fi-app
//
//  Created by júlia fazenda ruiz on 27/05/25.
//


import UIKit

class CategoryCollectionViewListSectionHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "CollectionViewListSectionHeader"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.taskCategory
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .background
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
}

// MARK: ViewCodeProtocol
extension CategoryCollectionViewListSectionHeader: ViewCodeProtocol {
    func addSubviews() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
           
        ])
    }
}




