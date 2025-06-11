//
//  AvatarCreation.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 11/06/25.
//

import UIKit

class AvatarCreationViewController: UIViewController {
    // MARK: - Hair
    lazy var avatarHairStackView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.hair1
        return imageView
    }()
    
    // MARK: - Shirt
    lazy var avatarShirtStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .blue
        return stackView
    }()
    
    // MARK: - Pants
    lazy var avatarPantsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .red
        return stackView
    }()
    
    // MARK: - Avatar
    lazy var avatarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarHairStackView, avatarShirtStackView, avatarPantsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .darkGray
        return stackView
    }()
    
    // MARK: - Button Hair
    lazy var changeHairButton1: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hair1", for: .normal)
        button.addTarget(self, action: #selector(changeHair(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var changeHairButton2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hair2", for: .normal)
        button.addTarget(self, action: #selector(changeHair(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var changeHairButton3: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hair3", for: .normal)
        button.addTarget(self, action: #selector(changeHair(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var changeHairButton4: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hair4", for: .normal)
        button.addTarget(self, action: #selector(changeHair(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var changeHairStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeHairButton1, changeHairButton2, changeHairButton3, changeHairButton4])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Button Shirt
    lazy var changeShirtButton1: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Shirt1", for: .normal)
        return button
    }()
    
    lazy var changeShirtButton2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Shirt2", for: .normal)
        return button
    }()
    
    lazy var changeShirtButton3: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Shirt3", for: .normal)
        return button
    }()
    
    lazy var changeShirtButton4: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Shirt4", for: .normal)
        return button
    }()
    
    lazy var changeShirtStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeShirtButton1, changeShirtButton2, changeShirtButton3, changeShirtButton4])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Button Pants
    lazy var changePantsButton1: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pants1", for: .normal)
        return button
    }()
    
    lazy var changePantsButton2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pants2", for: .normal)
        return button
    }()
    
    lazy var changePantsButt3n: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pants3", for: .normal)
        return button
    }()
    
    lazy var changePantsButton4: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pants4", for: .normal)
        return button
    }()
    
    lazy var changePantsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changePantsButton1, changePantsButton2, changePantsButt3n, changePantsButton4])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Stack Button
    lazy var changeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [changeHairStackView, changeShirtStackView, changePantsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
    }
    
    @objc func changeHair(sender: UIButton) {
        switch sender {
            case changeHairButton1:
            avatarHairStackView.image = UIImage.hair1
            case changeHairButton2:
            avatarHairStackView.image = UIImage.hair2
            case changeHairButton3:
            avatarHairStackView.image = UIImage.hair3
            case changeHairButton4:
            avatarHairStackView.image = UIImage.hair4
            default:
                break
        }
    }
    
    @objc func changeShirt() {
        
    }
    
    @objc func changePants() {
        
    }
}

// MARK: - Extensions
extension AvatarCreationViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(avatarStackView)
        view.addSubview(changeButtonStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarStackView.widthAnchor.constraint(equalToConstant: 300),
            avatarStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            avatarHairStackView.widthAnchor.constraint(equalToConstant: 100),
            avatarHairStackView.heightAnchor.constraint(equalToConstant: 100),
            
            avatarShirtStackView.widthAnchor.constraint(equalToConstant: 200),
            avatarShirtStackView.heightAnchor.constraint(equalToConstant: 200),
            
            avatarPantsStackView.widthAnchor.constraint(equalToConstant: 100),
            avatarPantsStackView.heightAnchor.constraint(equalToConstant: 150),
            
            changeButtonStackView.topAnchor.constraint(equalTo: avatarStackView.bottomAnchor, constant: 20),
            changeButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
