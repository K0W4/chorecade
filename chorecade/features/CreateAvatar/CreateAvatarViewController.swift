//
//  CreateAvatarViewController.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 25/06/25.
//
import UIKit

class CreateAvatarViewController: UIViewController {
    
    var selectedCharacter: UIImage?
    var selectedCharacterHead: UIImage?
    
    lazy var doneButton = Components.getButton(
        content: "Done",
        action: #selector(doneButtonAction),
        font: Fonts.titleScreen,
        size: 40
    )
    
    lazy var characterFull: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "default")
        return imageView
    }()
    
    lazy var titleLabel = Components.getLabel(
        content: "Choose your character",
        font: Fonts.characterLabel,
        alignment: .center
    )
    
    // --- Avatar 1 ---
    lazy var headFem1Image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "fem1-head")
        return imageView
    }()
    
    lazy var headFem1Stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headFem1Image])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.backgroundColor = .clear
        return stack
    }()
    
    // --- Avatar 2 ---
    lazy var headFem2Image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "fem2-head")
        return imageView
    }()
    
    lazy var headFem2Stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headFem2Image])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.backgroundColor = .clear
        return stack
    }()
    
    lazy var femStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headFem1Stack, headFem2Stack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    // --- Avatar 3 ---
    lazy var headMasc1Image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "masc1-head")
        return imageView
    }()
    
    lazy var headMasc1Stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headMasc1Image])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.backgroundColor = .clear
        return stack
    }()
    
    // --- Avatar 4 ---
    lazy var headMasc2Image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "masc2-head")
        return imageView
    }()
    
    lazy var headMasc2Stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headMasc2Image])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.backgroundColor = .clear
        return stack
    }()
    
    lazy var mascStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headMasc1Stack, headMasc2Stack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    var allHeadStacks: [UIStackView] {
        [headFem1Stack, headFem2Stack, headMasc1Stack, headMasc2Stack]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .background
        navigationController?.navigationBar.isHidden = true
        
        guard let fem1 = UIImage(named: "fem1"),
              let fem2 = UIImage(named: "fem2"),
              let masc1 = UIImage(named: "masc1"),
              let masc2 = UIImage(named: "masc2") else {
            print("Erro: uma ou mais imagens não foram encontradas.")
            return
        }
        
        addTapGesture(to: headFem1Stack, image: fem1, imageName: "fem1")
        addTapGesture(to: headFem2Stack, image: fem2, imageName: "fem2")
        addTapGesture(to: headMasc1Stack, image: masc1, imageName: "masc1")
        addTapGesture(to: headMasc2Stack, image: masc2, imageName: "masc2")
    }
    
    @objc func doneButtonAction() {
        guard let selectedCharacter = selectedCharacter, let selectedCharacterHead = selectedCharacterHead else {
            let alert = UIAlertController(title: "Attention", message: "Select a character!", preferredStyle: .alert)
            alert.view.tintColor = UIColor.primaryPurple300
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        Repository.addUserAvatar(avatar: selectedCharacter, avatarHead: selectedCharacterHead) { sucesso in
            DispatchQueue.main.async {
                if sucesso {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.changeRootViewController(UserDataViewController(avatarImage: selectedCharacter))
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Could not save the avatar. Try again later!", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.primaryPurple300
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    func addTapGesture(to stack: UIStackView, image: UIImage, imageName: String) {
        image.accessibilityIdentifier = imageName
        let tap = AvatarTapGestureRecognizer(target: self, action: #selector(headTapped(_:)))
        tap.avatarImage = image
        tap.stackView = stack
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tap)
    }
    
    @objc func headTapped(_ sender: AvatarTapGestureRecognizer) {
        for stack in allHeadStacks {
            stack.backgroundColor = .clear
        }
        sender.stackView?.backgroundColor = .primaryPurple300
        characterFull.image = sender.avatarImage
        if let image = sender.avatarImage,
           let imageName = image.accessibilityIdentifier {
            selectedCharacter = image
            selectedCharacterHead = UIImage(named: "\(imageName)-head")
        }
    }
}

class AvatarTapGestureRecognizer: UITapGestureRecognizer {
    var avatarImage: UIImage?
    var stackView: UIStackView?
}

extension CreateAvatarViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(doneButton)
        view.addSubview(characterFull)
        view.addSubview(titleLabel)
        view.addSubview(femStack)
        view.addSubview(mascStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.widthAnchor.constraint(equalToConstant: 95),
            
            characterFull.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 24),
            characterFull.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterFull.widthAnchor.constraint(equalToConstant: 200),
            characterFull.heightAnchor.constraint(equalToConstant: 260),
            
            titleLabel.topAnchor.constraint(equalTo: characterFull.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            femStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            femStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 46),
            femStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -46),
            femStack.heightAnchor.constraint(equalToConstant: 128),
            
            mascStack.topAnchor.constraint(equalTo: femStack.bottomAnchor, constant: 24),
            mascStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 46),
            mascStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -46),
            mascStack.heightAnchor.constraint(equalToConstant: 128),
            
            headFem1Stack.widthAnchor.constraint(equalToConstant: 128),
            headFem2Stack.widthAnchor.constraint(equalToConstant: 128),
            headMasc1Stack.widthAnchor.constraint(equalToConstant: 128),
            headMasc2Stack.widthAnchor.constraint(equalToConstant: 128)
        ])
    }
}
