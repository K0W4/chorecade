//
//  Persistence.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 21/06/25.
//

import Foundation
import UIKit

struct Persistence {
    private static let groupKey = "groupKey"
    private static let taskKey = "taskKey"
    private static let userKey = "users"
    private static let userLoggedKey = "userLogged"
    
    // MARK: Users
    
    static func getUsers() -> Accounts? {
        
        if let data = UserDefaults.standard.value(forKey: userKey) as? Data {
            
            do {
                let users = try JSONDecoder().decode(Accounts.self, from: data)
                return users
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    static func saveAccounts (accounts: Accounts) {
        
        do {
            let data = try JSONEncoder().encode(accounts)
            UserDefaults.standard.setValue(data, forKey: userKey)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func saveUser(newUser: User) {
        
        var accounts = getUsers() ?? Accounts(users: [])
        
        accounts.users.append(newUser)
        
        saveAccounts(accounts: accounts)
        
    }
    
    //    static func deleteUser(userEmail: String) {
    //        if Persistence.getLoggedUser()?.email == userEmail {
    //            Persistence.logoutUser()
    //        }
    //
    //        var accounts = getUsers()?.users
    //
    //        accounts?.removeAll { $0.email == userEmail }
    //
    //        saveAccounts(accounts: Accounts(users: accounts ?? []))
    //
    //    }
    
    // MARK: LoggedUser --------------------------------
    
    static func saveLoggedUser(user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.setValue(data, forKey: userLoggedKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getLoggedUser() -> User? {
        if let data = UserDefaults.standard.value(forKey: userLoggedKey) as? Data {
            
            do {
                let userLogged = try JSONDecoder().decode(User.self, from: data)
                return userLogged
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: userLoggedKey)
    }
    
    // MARK: Groups
    
    static func getGroups() -> CreatedGroups? {
        
        if let data = UserDefaults.standard.value(forKey: groupKey) as? Data {
            
            do {
                let group = try JSONDecoder().decode(CreatedGroups.self, from: data)
                return group
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    static func saveGroupList(groupList: CreatedGroups) {
        do {
            let data = try JSONEncoder().encode(groupList)
            UserDefaults.standard.setValue(data, forKey: groupKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func addGroup(newGroup: Group) {
        
        var groupList = getGroups() ?? CreatedGroups(groups: [])
        
        groupList.groups.append(newGroup)
        
        saveGroupList(groupList: groupList)
        
    }
    
    static func updateGroup(group: Group) {
        guard var allGroups = getGroups()?.groups else { return }
        
        if let index = allGroups.firstIndex(where: {$0.id == group.id }) {
            allGroups[index] = group
            saveGroupList(groupList: CreatedGroups(groups: allGroups))
        }
    }
    
    // MARK: Task
    
    private static func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        // MARK: - Image Persistence Functions
        static func saveImageToFileSystem(image: UIImage, prefix: String) -> String? {
            guard let data = image.jpegData(compressionQuality: 0.8) else { // Use JPEG for smaller size, adjust quality as needed
                print("ERROR: Could not get JPEG data from image.")
                return nil
            }
            
            let filename = "\(prefix)_\(UUID().uuidString).jpeg" // Create a unique filename
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            
            do {
                try data.write(to: fileURL)
                print("DEBUG: Image saved to \(fileURL.lastPathComponent)")
                return filename // Return only the filename, not the full path
            } catch {
                print("ERROR: Could not save image to file system: \(error.localizedDescription)")
                return nil
            }
        }
    
    static func loadImageFromFileSystem(filename: String) -> UIImage? {
           let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
           
           do {
               let data = try Data(contentsOf: fileURL)
               print("DEBUG: Image loaded from \(filename)")
               return UIImage(data: data)
           } catch {
               print("ERROR: Could not load image from file system: \(error.localizedDescription)")
               return nil
           }
       }
    
    static func getAllTasks() -> CreatedTask? {
        if let data = UserDefaults.standard.value(forKey: taskKey) as? Data {
            do {
                let taskContainer = try JSONDecoder().decode(CreatedTask.self, from: data)
                return taskContainer
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    // Retorna apenas as tasks do grupo correspondente
    static func getTasks(for groupId: UUID) -> [Task] {
        if let data = UserDefaults.standard.value(forKey: taskKey) as? Data {
            do {
                let taskContainer = try JSONDecoder().decode(CreatedTask.self, from: data)
                return taskContainer.tasks.filter { $0.group?.id == groupId
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    // Salva uma lista de Task como CreatedTask
    static func saveTaskList(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(CreatedTask(tasks: tasks))
            UserDefaults.standard.setValue(data, forKey: taskKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Adiciona uma nova task ao grupo correspondente
//    static func addTask(newTask: Task) {
//        guard let groupId = newTask.group?.id else { return }
//        var allTasks = getTasks(for: groupId)
//        allTasks.append(newTask)
//        saveTaskList(allTasks)
//    }
    
    static func addTask(newTask: Task) {
            var allExistingTasks = getAllTasks()?.tasks ?? []
            allExistingTasks.append(newTask)
            saveTaskList(allExistingTasks)
        
        print("Tarefa Adicionada!")
        }
    
    
    static func updateTask(task: Task) {
           var allExistingTasks = getAllTasks()?.tasks ?? []
           if let index = allExistingTasks.firstIndex(where: { $0.id == task.id }) {
               allExistingTasks[index] = task
               saveTaskList(allExistingTasks)
           }
       }
   
}
