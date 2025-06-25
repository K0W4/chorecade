//
//  AddNewTaskModalViewController.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 16/06/25.
//

import UIKit

protocol AddNewTaskModalDelegate: AnyObject {
    func didAddTask()
}

class AddNewTaskModalViewController: UIViewController {
    
    // MARK: Variables
    
    var activePhotoComponent: PhotoComponent?
    var selectedCategory: Category?
    var selectedGroup: Group?
    weak var delegate: AddNewTaskModalDelegate?
    
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
        let stackView = UIStackView(arrangedSubviews: [
            addBeforePhoto, addAfterPhoto,
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var categoryButton = Components.getButton(
        content: "Category",
        action: #selector(handleCategoryButton),
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
        placeholder: "Ex: Cleaned the airfryer too",
        delegate: self
    )
    
    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            descriptionLabel, descriptionTextField,
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addPhotoStackView, categoryButton, categorySelectionView,
            descriptionStackView,
        ])
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
        
        let tapDismissKeyboard = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
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
        Task {
            // o código que era async, incluindo await e try await
            // por exemplo:
            guard let group = selectedGroup else {
                let termsAlert = UIAlertController(
                    title: "Error!",
                    message: "No group selected for this task.",
                    preferredStyle: .alert
                )
                termsAlert.addAction(UIAlertAction(title: "OK", style: .default))
                present(termsAlert, animated: true, completion: nil)
                return
            }
            
            guard let beforeImage = addBeforePhoto.selectedImage else {
                let termsAlert = UIAlertController(
                    title: "Warning!",
                    message: "Add a photo before you start cleaning",
                    preferredStyle: .alert
                )
                
                termsAlert.addAction(UIAlertAction(title: "OK", style: .default))
                present(termsAlert, animated: true, completion: nil)
                
                return
            }
            
            let afterImage = addAfterPhoto.selectedImage
            
            guard let category = selectedCategory else {
                let termsAlert = UIAlertController(
                    title: "Warning!",
                    message: "Select a category",
                    preferredStyle: .alert
                )
                
                termsAlert.addAction(UIAlertAction(title: "OK", style: .default))
                present(termsAlert, animated: true, completion: nil)
                
                return
            }
            
            let descriptionText = descriptionTextField.text ?? ""
            
            if let currentUserID = Repository.userRecordID {
                do {
                    
                    try await Repository.addTask(
                        toGroupWithCode: group.groupCode,
                        category: category.id,
                        description: descriptionText,
                        points: category.points,
                        userId: currentUserID,
                        photoBefore: beforeImage,
                        photoAfter: afterImage
                    )
                    
                    await Repository.addPointsToCurrentUser(category.points)
                } catch {
                    print("Error")
                }
                
                    self.delegate?.didAddTask()
               
                dismiss(animated: true)
            }
        }
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
            
            headerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            
            // Stack View
            
            stackView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 32
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])
    }
    
}

extension AddNewTaskModalViewController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else { return }

        activePhotoComponent?.selectedImage = image
    }
}

extension AddNewTaskModalViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == descriptionTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updatedText = currentText.replacingCharacters(
                in: stringRange,
                with: string
            )
            return updatedText.count <= 42
        }
        return true
    }
}
