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
            return categories.filter { $0.level == 1 }.count
        } else if section == 1 {
            return categories.filter { $0.level == 2 }.count
        }
        return categories.filter { $0.level == 3 }.count
        
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
            "Simple Tasks",
            "Medium Tasks",
            "Big Tasks"]
        
        header.configure(with: sectionTitles[indexPath.section])
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewListCell.identifier, for: indexPath) as? CategoryCollectionViewListCell else {
            fatalError("Cell not found")
        }
        
        if indexPath.section == 0 {
            let category = categories.filter { $0.level == 1 }[indexPath.item]
            cell.configure(
                title: category.title,
                points: category.points,
            )
        } else if indexPath.section == 1 {
            let category = categories.filter { $0.level == 2 }[indexPath.item]
            cell.configure(
                title: category.title,
                points: category.points,
            )
        } else {
            let category = categories.filter { $0.level == 3 }[indexPath.item]
            cell.configure(
                title: category.title,
                points: category.points,
            )
        }
       
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.background
        backgroundView.clipsToBounds = true
        cell.backgroundView = backgroundView
        
        return cell
    }
    
    
}

