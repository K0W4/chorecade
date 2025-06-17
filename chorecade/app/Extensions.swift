//
//  Extensions.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 16/06/25.
//
import Foundation
import UIKit

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
