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

extension UIColor {
    static var namedColors: [String: UIColor] {
        let names = [
            "selection-blue",
            "selection-green",
            "selection-yellow",
            "selection-red",
            "selection-orange",
            "selection-purple"
        ]
        
        var colors: [String: UIColor] = [:]
        for name in names {
            if let color = UIColor(named: name) {
                colors[name] = color
            }
        }
        return colors
    }
}
