//
//  GroupEmptyState.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 21/06/25.
//

import UIKit

class GroupEmptyState: UIView {

    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.nameTasksCategories
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black50
        return label
    }()

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GroupEmptyState: ViewCodeProtocol {
    func setup() {
        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        addSubview(descriptionLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 89),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 63
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -63
            )
        ])
    }

}
