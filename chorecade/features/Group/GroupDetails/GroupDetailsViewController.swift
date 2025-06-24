//
//  GroupDetailsViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 24/06/25.
//

import UIKit
import CloudKit

class GroupDetailsViewController: UIViewController {
    
    // MARK: Components
    private lazy var headerView: ModalHeader = {
        var header = ModalHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Group Details"
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    lazy var groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var groupLabel = Components.getLabel(content: "")
    
    lazy var codeLabel = Components.getLabel(content: "Code:")
    
    lazy var copyCodeLabel = Components.getLabel(content: "")
    
    lazy var copyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "document")
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var prizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = Fonts.titleConcludedTask
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    lazy var prizeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [prizeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        let bgColorView = UIView()
        stackView.layer.borderColor = UIColor(named: "primaryPurple300")?.cgColor
        stackView.layer.borderWidth = 1
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: Override ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        setup()
        
        
    }
    
    // MARK: Functions
    @objc func addButtonTapped() {
        
    }
}

extension GroupDetailsViewController: ViewCodeProtocol {
    func addSubviews() {
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            
        ])
    }
}
//
//extension GroupDetailsViewController: UITableViewDelegate, UITableViewDataSource {
//    
//}
