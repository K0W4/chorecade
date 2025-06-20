//
//  RankingViewController.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 18/06/25.
//

import UIKit
import Foundation

public class RankingViewController: UIViewController {
    
    lazy var emptyStateRanking: EmptyState = {
        var empty = EmptyState()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.titleText = "Ranking"
        empty.descriptionText = "Add your friends in \"Create Group\""
        return empty
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
        view.addSubview(emptyStateRanking)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateRanking.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateRanking.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateRanking.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
