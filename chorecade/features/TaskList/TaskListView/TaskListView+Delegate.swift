//
//  TaskListView+Delegate.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 20/06/25.
//

import UIKit
import Foundation

extension TaskListView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 136
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTask = tasksByGroup[indexPath.row]
        
        onTaskSelected?(selectedTask)
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
