//
//  RankingView+Delegate.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 24/06/25.
//

import UIKit
import Foundation

extension RankingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let selectedTask = tasksByGroup[indexPath.row]
//        
//        onTaskSelected?(selectedTask)
//       
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
