//
//  EmptyTableViewCell.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 21/06/25.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    lazy var emptyStateLabel = Components.getLabel(
        content: "Click on “add a new task” to add a new task",
        font: Fonts.nameTasksCategories,
        textColor: .systemGray2,
        alignment: .center
    )
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
        
        emptyStateLabel.numberOfLines = 2
        emptyStateLabel.lineBreakMode = .byWordWrapping
       
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmptyTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        addSubview(emptyStateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    
}
