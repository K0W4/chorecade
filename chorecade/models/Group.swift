//
//  Group.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit

class Group {
    var name: String
    
    var groupImage: UIImage? = nil
    
    var startDate: Date
    var duration: Int
    
    
    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: duration, to: startDate) ?? Date()
    }
    
    var prize: String
    
    var users: [User] = []
    
    var tasks: [Taskk] = []
    
    init(name: String, startDate: Date, duration: Int, prize: String) {
        self.name = name
        self.startDate = startDate
        self.duration = duration
        self.prize = prize
    }
}
