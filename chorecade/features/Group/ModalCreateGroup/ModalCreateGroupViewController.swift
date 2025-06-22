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
    private lazy var headerView: ModalHeader = {
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
    
    private lazy var addGroupPhoto: PhotoComponent = {
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
    
    private lazy var nameStackView: UIStackView = {
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
    
    private lazy var rewardStackView: UIStackView = {
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
    
    private lazy var colorsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 13
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 361),
            imageView.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        return imageView
    }()
    
    private lazy var colorsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [colorLabel, colorsImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
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
    
    private lazy var monthlyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .primaryPurple100
        
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont(name: "Jersey10-Regular", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Monthly", for: .normal)
        button.layer.cornerRadius = 13

        return button
    }()
    
    private lazy var weeklyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .primaryPurple100
        
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont(name: "Jersey10-Regular", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Weekly", for: .normal)
        button.layer.cornerRadius = 13

        return button
    }()
    
    private lazy var biweeklyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .primaryPurple100
        
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont(name: "Jersey10-Regular", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Biweekly", for: .normal)
        button.layer.cornerRadius = 13

        return button
    }()
    
    private var filterButtons: [UIButton] {
        return [monthlyButton, weeklyButton, biweeklyButton]
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        for button in filterButtons {
            button.backgroundColor = .primaryPurple100
        }

        sender.backgroundColor = .primaryPurple300

        // Aqui você pode aplicar o filtro, se quiser
    }
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [monthlyButton, weeklyButton, biweeklyButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var labelButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [periodLabel, buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameStackView, rewardStackView, colorsStackView, labelButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
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
        view.addSubview(addGroupPhoto)
        view.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Header View
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // Add Group Photo
            
            addGroupPhoto.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            addGroupPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 111),
            addGroupPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -111),
            addGroupPhoto.heightAnchor.constraint(equalToConstant: 171),
            
            // Main Stack
            
            mainStackView.topAnchor.constraint(equalTo: addGroupPhoto.bottomAnchor, constant: 32),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
}

extension ModalCreateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        activePhotoComponent?.selectedImage = image
    }
}
