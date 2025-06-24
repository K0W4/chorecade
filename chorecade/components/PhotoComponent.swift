//
//  PhotoComponent.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 16/06/25.
//


import UIKit
import Photos
import AVFoundation

class PhotoComponent: UIView {
    
    // MARK: Variables
    
    var hasAcceptedTerms: Bool = false
    
    var onPhotoRequest: (() -> Void)?
    
    weak var viewController: UIViewController?
    
    // MARK: Views
    
    lazy var label = Components.getLabel(
        content: "",
        font: Fonts.titleScreen,
        textColor: UIColor.black.withAlphaComponent(0.5),
        alignment: .center
    )
    
    lazy var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .secondaryBlue
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .vertical
        stackView.backgroundColor = .primaryPurple100
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.layer.cornerRadius = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPhotoOptions))
        stackView.addGestureRecognizer(tapGesture)
        
        return stackView
    }()
    
    lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    var labelText: String? {
        didSet {
            label.text = labelText
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            updateStackWithImage()
        }
    }
    
    // MARK: Functions
    
    @objc func showPhotoOptions() {
        onPhotoRequest?()
        
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in self.openCamera() }
        
        let galeryAction = UIAlertAction(title: "Gallery", style: .default) { _ in self.openPhotoLibrary() }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galeryAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: função pra verificar se o usuario liberou a camera
    func openCamera() {
        guard let viewController = viewController else { return }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            presentCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        self.presentAccessAlert(
                            from: viewController,
                            title: "We need access to your camera to take photos.",
                            message: "Please enable camera access in Settings: Settings > Chorecade > Camera."
                        )
                    }
                }
            }
            
        case .denied, .restricted:
            presentAccessAlert(from: viewController)
            
        @unknown default:
            break
        }
    }
    
    // MARK: função pra abrir camera
    func presentCamera() {
        guard let viewController = viewController else { return }
        
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .camera
        photoPicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        viewController.present(photoPicker, animated: true, completion: nil)
    }
    
    // MARK: função pra abrir alerta
    func presentAccessAlert(from viewController: UIViewController, title: String? = nil, message: String? = nil) {
        let termsAlert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        termsAlert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        termsAlert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(termsAlert, animated: true, completion: nil)
    }
    
    // MARK: função pra verificar se o usuario liberou a galeria
    func openPhotoLibrary() {
        guard let viewController = viewController else { return }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            presentPhotoLibrary()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.presentPhotoLibrary()
                    } else {
                        self.presentAccessAlert(
                            from: viewController,
                            title: "We need access to your galery to choose photos.",
                            message: "To select photos and register completed tasks, allow photo access in Settings. Go to Settings > Chorecade > Photos and select 'All Photos' or 'Selected Photos' to enable it."
                        )
                    }
                }
            }
            
        case .denied, .restricted:
            presentAccessAlert(
                from: viewController,
                title: "We need access to your galery to choose photos.",
                message: "To select photos and register completed tasks, allow photo access in Settings. Go to Settings > Chorecade > Photos and select 'All Photos' or 'Selected Photos' to enable it."
            )
            
        @unknown default:
            break
        }
    }
    
    // MARK: função pra abrir galeria
    func presentPhotoLibrary() {
        guard let viewController = viewController else { return }
        
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        viewController.present(photoPicker, animated: true, completion: nil)
    }
    
    func updateStackWithImage() {
        guard let image = selectedImage else {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            stackView.addArrangedSubview(iconImageView)
            stackView.addArrangedSubview(label)
            return
        }

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
        ])
    }
}

extension PhotoComponent: ViewCodeProtocol {
    func addSubviews() {
        addSubview(stackView)
        addSubview(selectedImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 202),
            
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 80),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            selectedImageView.topAnchor.constraint(equalTo: self.topAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 202),
            
            
        ])
    }
}


extension PhotoComponent: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        viewController?.dismiss(animated: true, completion: nil)

        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImageView.image = selectedImage
            selectedImageView.isHidden = false
            iconImageView.isHidden = true
            label.isHidden = true
        }
    }
}



