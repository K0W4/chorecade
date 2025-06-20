//
//  CategorySelector.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class GroupSelector: UIView {
    // MARK: Components
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Current Name"
        label.font = Fonts.nameOnTasks
        return label
    }()
    
    lazy var button: UIButton = {
        var buton = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = selectedGroup ?? "Select"
        config.indicator = .popup
        buton.configuration = config
        buton.menu = UIMenu(title: "Category", options: [.singleSelection], children: groupSelections)
        buton.showsMenuAsPrimaryAction = true
        return buton
    }()
    
    // MARK: Stack
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stack.backgroundColor = UIColor(named: "Background-Tertiary")
        stack.layer.cornerRadius = 8
        return stack
    }()
    
    // MARK: Data
    private let mockTitles: [String] = ["Clean litter box / pick up poop", "Brush pet’s fur", "Full house cleaning"]

    
    private var groupSelections: [UIAction] {
        mockTitles.map { title in
            UIAction(title: title) { [weak self] _ in
                self?.selectedGroup = title
            }
        }
    }
    
    var selectedGroup: String? {
        didSet {
            var config = button.configuration
            config?.title = selectedGroup ?? "Select"
            button.configuration = config
        }
    }
    
    // MARK: Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: Extensions
extension GroupSelector: ViewCodeProtocol {
    func addSubviews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
}
