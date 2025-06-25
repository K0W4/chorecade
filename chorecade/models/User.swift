//
//  User.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit 
import CloudKit

struct User {
    var groupCodes: [String]
    var nickname: String
    
    var points: Int
    
    let recordID: CKRecord.ID
    var title: String?
    
    var avatar: Avatar = Avatar()
    
    var achievements: [Achievement] = Defaults.defaultAchievements
    
    var taskCounter: [TaskType : Int] = [:]
}
