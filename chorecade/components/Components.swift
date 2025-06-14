//
//  Components.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 06/06/25.
//
import UIKit

struct Components {
    
    // MARK: - Get label
    static func getLabel(
        content: String,
        font: UIFont? = UIFont.systemFont(ofSize: 17),
        fontSize: Int = 17,
        textColor: UIColor = .red,
        alignment: NSTextAlignment = .justified,
        hiden: Bool = false
    ) -> UILabel {
        
        if font == nil {
            print("Font not found for \(content)")
            
        }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = content
        label.textAlignment = alignment
        label.textColor = textColor
        label.font = font
        label.isHidden = hiden
        
        return label
    }
    
    // MARK: - Get textField
    static func getTextField(
        placeholder: String = "",
        isPassword: Bool = false,
        height: Int = 46,
        delegate: UITextFieldDelegate? = nil
    ) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.tintColor = .cyan
        textField.textColor = .cyan
        textField.backgroundColor = .yellow
        textField.isSecureTextEntry = isPassword
        textField.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 8
        
        if delegate != nil {
            textField.delegate = delegate
        }
        
        // Add internal padding
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        
        return textField
    }
    
    // MARK: - Get button
    static func getButton(
        content: String = "",
        image: UIImage? = nil,
        action: Selector,
        font: UIFont? = UIFont.systemFont(ofSize: 17),
        fontSize: Int = 17,
        textColor: UIColor = .white,
        backgroundColor: UIColor = .cyan,
        cornerRadius: Int = 8,
        size: Int = 46
    ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = font
        button.setTitleColor(textColor, for: .normal)
        
        if let _ = image {
            button.setImage(image, for: .normal)
            button.tintColor = textColor
        } else {
            button.setTitle(content, for: .normal)
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = CGFloat(cornerRadius)
        
        button.heightAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
        
        
        return button
    }
    
    
}
