//
//  Group.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation

struct Group: Codable {
    let id: UUID
    
    var name: String
    
    var startDate: Date
    var duration: TimeInterval
    
    var endDate: Date {
        startDate + duration
    }
    
    var prize: String
    
    var users: [User] = []
    
    var tasks: [Task] = []
    
}
