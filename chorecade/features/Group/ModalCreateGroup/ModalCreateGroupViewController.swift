//
//  ModalCreateGroupViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 21/06/25.
//

import UIKit

class ModalCreateGroupViewController: UIViewController {
    
    // MARK: Variables
    var activePhotoComponent: PhotoComponent?
    
    // MARK: Components
    lazy var headerView: ModalHeader = {
        var header = ModalHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Create Group"
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    lazy var addGroupPhoto: PhotoComponent = {
        var photo = PhotoComponent()
        photo.viewController = self
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Name:"
        label.textColor = .black
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = Components.getTextField(placeholder: "Ex: My Family")
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()
    
    private lazy var rewardLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Reward:"
        label.textColor = .black
        return label
    }()
    
    private lazy var rewardTextField: UITextField = {
        let textField = Components.getTextField(placeholder: "Ex: Dinner at McDonald's")
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    lazy var rewardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rewardLabel, rewardTextField])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        rewardTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rewardTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            rewardTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        return stackView
    }()
    
    private lazy var colorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Color:"
        label.textColor = .black
        return label
    }()
    
    lazy var colorsImage: UIImageView = {
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
    
    private lazy var periodLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Competition period (when the prize is calculated):"
        label.textColor = .black
        return label
    }()
    
    // MARK: Proprieties
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setup()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        addGroupPhoto.onPhotoRequest = { [weak self] in
            self?.activePhotoComponent = self?.addGroupPhoto
        }
        
        
    }
    
    // MARK: Functions
    @objc func addButtonTapped() {
        
    }
}

extension ModalCreateGroupViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(headerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Header View
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
}
