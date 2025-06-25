//
//  RankinView+DataSource.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 24/06/25.
//

import UIKit
import Foundation

extension RankingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let isEmpty = tasksByGroup.isEmpty
//        return isEmpty ? 1 : tasksByGroup.count
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "empty-list-cell", for: indexPath) as? EmptyTableViewCell else {
                        return UITableViewCell()
                    }
        
        
//        if tasksByGroup.isEmpty {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "empty-list-cell", for: indexPath) as? EmptyTableViewCell else {
//                return UITableViewCell()
//            }
//            
//            cell.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            cell.isUserInteractionEnabled = false
//            
//            
//            return cell
//        }
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ranking-cell", for: indexPath) as? TaskListTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let task = tasksByGroup[indexPath.row]
//        
//        guard let userRecord = Repository.userRecord else {
//            print("No user record found")
//            return cell
//        }
//        
//        let userName = userRecord["nickname"] as? String ?? "Default nickname"
//        
//        print("userRecord: \(userRecord)")
//        print("nickname field: \(userRecord["nickname"] ?? "not found")")
        
        
        return cell
    }
}
