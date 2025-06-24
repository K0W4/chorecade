//
//  RankingViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 18/06/25.
//

import UIKit
import Foundation

public class RankingViewController: UIViewController {
    lazy var emptyStateRanking: RankingEmptyStateView = {
        var empty = RankingEmptyStateView()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.titleText = "Ranking"
        empty.descriptionText = "Add your friends in \"Create Group\""
        return empty
    }()
    
    lazy var rankingView: RankingView = {
        var rankingView = RankingView()
        rankingView.translatesAutoresizingMaskIntoConstraints = false
        return rankingView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setup()
    }
}

extension RankingViewController: ViewCodeProtocol {
    func setup() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(rankingView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rankingView.topAnchor.constraint(equalTo: view.topAnchor),
            rankingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rankingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rankingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            emptyStateRanking.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            emptyStateRanking.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            emptyStateRanking.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
