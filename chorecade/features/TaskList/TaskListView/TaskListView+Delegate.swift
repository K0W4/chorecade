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
        // open tela de detalhes
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
