//
//  Group.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation

class Group {
    let id: UUID = UUID()
    
    var name: String
    
    var startDate: Date
    var duration: TimeInterval
    
    var endDate: Date {
        startDate + duration
    }
    
    var prize: String
    
    var users: [User] = []
    
    var tasks: [Task] = []
    
    init(name: String, startDate: Date, duration: TimeInterval, prize: String) {
        self.name = name
        self.startDate = startDate
        self.duration = duration
        self.prize = prize
    }
}
