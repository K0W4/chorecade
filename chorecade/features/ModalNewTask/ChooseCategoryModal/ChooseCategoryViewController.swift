//
//  ChooseCategoryViewController.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 17/06/25.
//

import UIKit

class ChooseCategoryViewController: UIViewController {
    
    // MARK: Views
    
    lazy var headerView: ModalHeader = {
        var header = ModalHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Category"
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        header.showsSearchBar = true
        
        return header
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.showsSeparators = false
        config.backgroundColor = .clear
        
        
        
//        config.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
//
//            if indexPath.section == 0 && unpaidExpenses.isEmpty {
//                       return nil
//                   } else if indexPath.section == 1 && paidExpenses.isEmpty {
//                       return nil
//                   }
//           
//                   let deleteAction = UIContextualAction(
//                       style: .destructive,
//                       title: "Delete"
//                   ) {
//                       [weak self] (_, _, completionHandler) in
//           
//                       if indexPath.section == 0 {
//                           if self?.unpaidExpenses.isEmpty ?? true {
//                               return
//                           }
//                           if let expense = self?.unpaidExpenses[indexPath.row] {
//                               Persistance.deleteExpense(withId: expense.id)
//                           }
//                       } else if indexPath.section == 1 {
//                           if self?.paidExpenses.isEmpty ?? true {
//                               return
//                           }
//                           if let expense = self?.paidExpenses[indexPath.row] {
//                               Persistance.deleteExpense(withId: expense.id)
//                           }
//                       }
//           
//                       Persistance.saveChanges()
//                       self?.collectionView.reloadData()
//                       completionHandler(true)
//                   }
//           
//                   deleteAction.image = UIImage(systemName: "trash.fill")
//            
//            return .init(actions: [deleteAction])
//        }
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
                // Cria o layout da lista
                let listLayout = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
                listLayout.interGroupSpacing = 8
                return listLayout
            }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CategoryCollectionViewListCell.self, forCellWithReuseIdentifier: CategoryCollectionViewListCell.identifier)
        collectionView.register(
            CategoryCollectionViewListSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryCollectionViewListSectionHeader.reuseIdentifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    
    // MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .background
    }
    
    // MARK: Functions
    
    @objc func addButtonTapped() {
        print("oi")
    }
    


}

extension ChooseCategoryViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Header View
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // Collection View
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
}
