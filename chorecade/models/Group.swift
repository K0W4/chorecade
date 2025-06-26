//
//  Group.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit
import CloudKit

class Group {
    var name: String
    var id: CKRecord.ID
    var groupCode: String
    var groupImage: UIImage? = nil
    
    var startDate: Date
    var duration: Int
    
    var color: UIColor
    var createdBy: String?
    
    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: duration, to: startDate) ?? Date()
    }
    
    var prize: String
    
    var users: [User] = []
    
    var tasks: [Tasks] = []
    
    init(id: CKRecord.ID, name: String, startDate: Date, duration: Int, createdBy: String?, prize: String, groupImage: UIImage? = nil, users: [User] = [], tasks: [Tasks] = [], groupCode: String, color: UIColor) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.duration = duration
        self.createdBy = createdBy
        self.prize = prize
        self.groupImage = groupImage
        self.users = users
        self.tasks = tasks
        self.groupCode = groupCode
        self.color = color
        
        print("Group \(name) created for color \(color)")
    }
}
