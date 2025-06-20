//
//  SelectedCategory.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 18/06/25.
//

import UIKit
import Foundation


class SelectedCategory: UIView {
    
    lazy var categoryLabel = Components.getLabel(
        content: "",
        font: Fonts.taskTitleSelected
    )
    
    lazy var pointsLabel = Components.getLabel(content: "", font: Fonts.points, alignment: .center)
    
    lazy var pointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.layer.cornerRadius = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.preferredSymbolConfiguration = .init(pointSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    
    lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryLabel, UIView(), pointsStack, closeButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .secondaryBlue100
        stackView.layer.cornerRadius = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        categoryLabel.numberOfLines = 1
        categoryLabel.lineBreakMode = .byTruncatingTail
        categoryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        categoryLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        categoryLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onClose: (() -> Void) = {}
    
    var title : String? {
        didSet {
            categoryLabel.text = title
        }
    }
    
    var points: Int? {
        didSet {
            pointsLabel.text = "+\(points ?? 0) points"
        }
    }
    
    var selected: Bool = false {
        didSet {
            categoryStackView.isHidden = !selected
        }
    }
    
    @objc func handleCloseButton() {
        onClose()
    }
    
    
}

extension SelectedCategory: ViewCodeProtocol {
    func addSubviews() {
        addSubview(categoryStackView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: self.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            pointsStack.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
