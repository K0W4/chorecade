//
//  Achievement.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit

struct Achievement {
    let id: UUID = UUID()

    let title: String
    let description: String
    let icon: UIImage
    
    let requirement: (TaskType, Int)

    var isCompleted: Bool = false
    let isLegacy: Bool
}
