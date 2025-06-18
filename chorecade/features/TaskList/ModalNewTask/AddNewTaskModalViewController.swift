//
//  AddNewTaskModalViewController.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 16/06/25.
//

import UIKit

class AddNewTaskModalViewController: UIViewController {
    
    // MARK: Variables
    
    var activePhotoComponent: PhotoComponent?
    
    // MARK: Views
    
    lazy var headerView: ModalHeader = {
        var header = ModalHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "New Task"
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    lazy var addBeforePhoto: PhotoComponent = {
        var photo = PhotoComponent()
        photo.viewController = self
        photo.labelText = "Add the Before"
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    
    lazy var addAfterPhoto: PhotoComponent = {
        var photo = PhotoComponent()
        photo.viewController = self
        photo.labelText = "Add the After"
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    
    lazy var addPhotoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addBeforePhoto, addAfterPhoto])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var categoryButton = Components.getButton(
        content: "Category",
        action: #selector(handleCategoryButton),
        target: self,
        size: 58,
    )
    
    lazy var descriptionLabel = Components.getLabel(content: "Add Description")
    
    lazy var descriptionTextField = Components.getTextField(
        placeholder: "Ex: Cleaned the airfryer too"
    )
    
    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addPhotoStackView, categoryButton, descriptionStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setup()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        addBeforePhoto.onPhotoRequest = { [weak self] in
            self?.activePhotoComponent = self?.addBeforePhoto
        }

        addAfterPhoto.onPhotoRequest = { [weak self] in
            self?.activePhotoComponent = self?.addAfterPhoto
        }    }
    
    // MARK: Functions
    
    @objc func handleCategoryButton() {
        print("category button tapped")
    }
    
    @objc func addButtonTapped() {
        print("add button tapped")
        //        dismiss(animated: true)
    }
    
}

extension AddNewTaskModalViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Header View
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    
}

extension AddNewTaskModalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        activePhotoComponent?.selectedImage = image
    }
}
