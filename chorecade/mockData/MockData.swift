//
//  MockData.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 20/06/25.
//

import Foundation
import UIKit

struct MockData {
    static func initialize() {
        
        // MARK: - Usuários
        
        let user1 = User(nickname: "Luna", title: "Pet Hero")
        let user2 = User(nickname: "Max", title: "Organizer")
        let user3 = User(nickname: "Zoe", title: "Clean Master")
        let user4 = User(nickname: "Kai", title: "Chef Junior")
        
        let allUsers = [user1, user2, user3, user4]
        Persistence.saveAccounts(accounts: Accounts(users: allUsers))
        
        // MARK: - Grupos
        var choreSquad = Group(
            id: UUID(),
            name: "Chore Squad",
            startDate: Date(),
            duration: 60 * 60 * 24 * 14,
            prize: "Movie night",
            users: allUsers
        )
        
        let emptyGroup = Group(
            id: UUID(),
            name: "Teste Vazio",
            startDate: Date(),
            duration: 60 * 60 * 24 * 14,
            prize: "Movie night"
        )
        
        // MARK: - Tarefas
//        let task1 = Task(
//            id: UUID(),
//            category: CategoriesList.allCategories.first { $0.title == "Refill food bowl" }!,
//            description: "Fed Luna’s cat and cleaned the bowl.",
//            user: user1,
//            group: choreSquad
//        )
//        
//        let task2 = Task(
//            id: UUID(),
//            category: CategoriesList.allCategories.first { $0.title == "Organize drawers or closet" }!,
//            description: "Reorganized my wardrobe.",
//            user: user2,
//            group: choreSquad
//        )
//        
//        let task3 = Task(
//            id: UUID(),
//            category: CategoriesList.allCategories.first { $0.title == "Dust the furniture" }!,
//            description: "Dusted all shelves and desk in my room.",
//            user: user3,
//            group: choreSquad
//        )
//        
//        let task4 = Task(
//            id: UUID(),
//            category: CategoriesList.allCategories.first { $0.title == "Cook a full meal for everyone" }!,
//            description: "Prepared lunch for the whole family",
//            user: user4,
//            group: choreSquad
//        )
//        
//        let task5 = Task(
//            id: UUID(),
//            category: CategoriesList.allCategories.first { $0.title == "Water the plants" }!,
//            description: "Watered all indoor and balcony plants.",
//            user: user1,
//            group: nil
//        )
//        
//        let tasks = [task1, task2, task3, task4, task5]
//        choreSquad.tasks = tasks.filter { $0.group?.id == choreSquad.id }

        // MARK: - Salvar com Persistence
        Persistence.saveGroupList(groupList: CreatedGroups(groups: [choreSquad, emptyGroup]))
        
       // Persistence.saveTaskList(tasks)
    }
}
