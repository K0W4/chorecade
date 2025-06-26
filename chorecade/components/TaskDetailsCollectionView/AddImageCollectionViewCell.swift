//
//  AddImageCollectionViewCell.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 26/06/25.
//

import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {
    lazy var addIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        imageView.tintColor = .secondaryBlue
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
       
       
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddImageCollectionViewCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(addIcon)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
}

