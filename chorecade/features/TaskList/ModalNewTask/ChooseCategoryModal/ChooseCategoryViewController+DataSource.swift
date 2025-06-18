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
        let allCategories = CategoriesList.allCategories
        if section == 0 {
            return allCategories.filter { $0.nivel == 1 }.count
        } else if section == 1 {
            return allCategories.filter { $0.nivel == 2 }.count
        }
        return allCategories.filter { $0.nivel == 3 }.count
        
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
        
        let allCategories = CategoriesList.allCategories
  
        cell.configure(
            title: allCategories[indexPath.item].title,
           points: allCategories[indexPath.item].points,
        )
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.background
        backgroundView.clipsToBounds = true
        cell.backgroundView = backgroundView
        
        return cell
    }
    
    
}

