//
//  Avatar.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import UIKit

class Avatar {
    let baseAvatar: UIImage? = UIImage(named: "avatar")
    
    var heads: [UIImage] = Defaults.defaultsHeads
    var bodyss: [UIImage] = Defaults.defaultsBodys
    var shoes: [UIImage] = Defaults.defaultsShoes
    
    var hairIndex: Int = 0
    var shirtIndex: Int = 0
    var pantsIndex: Int = 0
}
