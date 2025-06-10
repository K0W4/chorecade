//
//  Task.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit

class Task {
    let id: UUID = UUID()
    
    let title: String
    let description: String
    
    let type: [TaskType]
    var level: Int
    
    let beforePic: UIImage? = nil
    let afterPic: UIImage? = nil
    
    var isDone: Bool = false
    
    init(title: String, description: String = "", type: [TaskType], level: Int) {
        self.title = title
        self.description = description
        self.type = type
        self.level = level
    }
}
