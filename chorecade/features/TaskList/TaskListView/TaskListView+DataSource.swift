//
//  TaskListView+DataSource.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 20/06/25.
//
import UIKit
import Foundation

extension TaskListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let isEmpty = tasksByGroup.isEmpty
        return isEmpty ? 1 : tasksByGroup.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tasksByGroup.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "empty-list-cell", for: indexPath) as? EmptyTableViewCell else {
                return UITableViewCell()
            }
            
            cell.heightAnchor.constraint(equalToConstant: 100).isActive = true
            cell.isUserInteractionEnabled = false
            
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskList-cell", for: indexPath) as? TaskListTableViewCell else {
            return UITableViewCell()
        }
        
        let task = tasksByGroup[indexPath.row]

        cell.taskTitleLabel.text = task.category.title
        cell.taskDescriptionLabel.text = task.description
        cell.taskPointsLabel.text = "+\(task.category.points) points"
        cell.taskImage.image = task.beforeImage
        cell.nameUserLabel.text = "..." // placeholder while loading

        Task {
            let user = await Repository.createUserModel(byRecordID: task.user)
            
            // To prevent race condition with reused cells
            if tableView.indexPath(for: cell) == indexPath {
                cell.nameUserLabel.text = user.nickname
            }
        }
        
        return cell
    }
    
}
