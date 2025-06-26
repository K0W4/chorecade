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
        let remainingUsers = usersByGroup.count > 3 ? Array(usersByGroup.dropFirst(3)) : []
        return remainingUsers.isEmpty ? 0 : remainingUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.reuseIdentifier, for: indexPath) as? RankingTableViewCell else {
            return UITableViewCell()
        }
        
        let remainingUsers = usersByGroup.count > 3 ? Array(usersByGroup.dropFirst(3)) : []
        guard indexPath.row < remainingUsers.count else { return cell }
        
        let user = remainingUsers[indexPath.row]
        guard let avatar = user.avatarHead else {
            return cell
        }
        
        cell.configure(
            name: user.nickname,
            points: user.points,
            position: indexPath.row + 4,
            avatar: avatar
        )
        
        return cell
    }
}
