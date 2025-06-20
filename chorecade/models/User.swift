//
//  User.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import CloudKit

class User {
    var groupCode: String?
    var nickname: String
    
    var title: String?
    
//    var icloudRecordID: CKRecord.ID
    
    var avatar: Avatar
    
    var achievements: [Achievement] = Defaults.defaultAchievements
    
    var taskCounter: [TaskType : Int]
    
    init(nickname: String, title: String? = nil, avatar: Avatar, achievements: [Achievement], taskCounter: [TaskType : Int]) {
        self.nickname = nickname
        self.title = title
        self.avatar = avatar
        self.achievements = achievements
        self.taskCounter = taskCounter
    }
}
