//
//  ChooseCategoryViewController+DataSource.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 17/06/25.
//


import Foundation
import UIKit

extension ChooseCategoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 12
        } else if section == 1 {
            return 10
        }
        return 5
        
    }
    
    // MARK: config header section
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoryCollectionViewListSectionHeader.reuseIdentifier,
            for: indexPath
        ) as! CategoryCollectionViewListSectionHeader
        
        
        let sectionTitles = [
            "Simple Tasks (5 - 10 points)",
            "Medium Tasks (15 - 25 points)",
            "Big Tasks (30 - 50 points)"]
        
        header.configure(with: sectionTitles[indexPath.section])
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        
        // Caso tenha despesas, mostra a cell normal
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewListCell.identifier, for: indexPath) as? CategoryCollectionViewListCell else {
            fatalError("Cell not found")
        }
        
        
        cell.configure(
            title: "Clean pet’s bed or resting area",
            points: 12
        )
        
        return cell
    }
    
    
}

