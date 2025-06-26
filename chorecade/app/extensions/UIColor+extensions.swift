//
//  Extensions.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 25/06/25.
//
import UIKit

extension UIColor {
    var toHex: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    convenience init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

            let length = hexSanitized.count
            switch length {
            case 6:
                let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                let b = CGFloat(rgb & 0x0000FF) / 255.0
                self.init(red: r, green: g, blue: b, alpha: 1.0)
            case 8:
                let r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                let g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                let b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                let a = CGFloat(rgb & 0x000000FF) / 255.0
                self.init(red: r, green: g, blue: b, alpha: a)
            default:
                return nil
            }
        }
}
