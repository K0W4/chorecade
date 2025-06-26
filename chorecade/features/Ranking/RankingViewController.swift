//
//  RankingViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 18/06/25.
//

import UIKit
import Foundation

public class RankingViewController: UIViewController {
    
    
    lazy var rankingView: RankingView = {
        var rankingView = RankingView()
        rankingView.translatesAutoresizingMaskIntoConstraints = false
        return rankingView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setup()
        
        navigationController?.isNavigationBarHidden = true
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reatribui o grupo atual e os usuários para atualizar os pontos
        if let currentGroup = Repository.currentGroup {
            let updatedUsers = currentGroup.users
            DispatchQueue.main.async {
                self.rankingView.currentSelectedGroup = currentGroup
                self.rankingView.usersByGroup = updatedUsers
            }
        }
    }

}

extension RankingViewController: ViewCodeProtocol {
    
    func addSubviews() {
        view.addSubview(rankingView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rankingView.topAnchor.constraint(equalTo: view.topAnchor),
            rankingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rankingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rankingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
}
