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
    var selectedCategory: Category?
    
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
    
    lazy var categorySelectionView: SelectedCategory = {
        var categoryComponent = SelectedCategory()
        categoryComponent.title = selectedCategory?.title ?? ""
        categoryComponent.points = selectedCategory?.points ?? 0
        categoryComponent.onClose = { [weak self] in
            self?.selectedCategory = nil
            self?.categorySelectionView.isHidden = true
        }
        categoryComponent.selected = true
        categoryComponent.isHidden = true
        return categoryComponent
    }()
        
    lazy var descriptionLabel = Components.getLabel(
        content: "Add Description",
        font: Fonts.descriptionLabel
    )
    
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
        let stackView = UIStackView(arrangedSubviews: [addPhotoStackView, categoryButton, categorySelectionView, descriptionStackView])
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
        }
    }

    
    
    // MARK: Functions
    
    @objc func handleCategoryButton() {
        
        let modalViewController = ChooseCategoryViewController()
        
        modalViewController.modalPresentationStyle = .pageSheet
        
        modalViewController.onCategorySelected = { [weak self] selected in
            self?.selectedCategory = selected
            self?.categorySelectionView.title = selected.title
            self?.categorySelectionView.points = selected.points
            self?.categorySelectionView.selected = true
            self?.categorySelectionView.isHidden = false
        }

        
        if let sheet = modalViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        present(modalViewController, animated: true)
    }
    
    @objc func addButtonTapped() {
        
        
        guard let beforeImage = addBeforePhoto.selectedImage else {
            print("You must select at least the 'before' photo.")
            return
        }

        print("BEFORE photo: selected \(beforeImage)")

        if let afterImage = addAfterPhoto.selectedImage {
            print("AFTER photo: selected")
        } else {
            print("AFTER photo: not selected")
        }

        if let category = selectedCategory {
            print("Category selected: \(category.title), Points: \(category.points), Level: \(category.nivel)")
        } else {
            print("No category selected")
        }

        let descriptionText = descriptionTextField.text ?? ""
        print("Description: \(descriptionText)")
        
    
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
            
            // Stack View
            
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
