//
//  ChooseCategoryViewController+Delegate.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 17/06/25.
//

import UIKit
import Foundation

// MARK: - UICollectionViewDelegate
extension ChooseCategoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            let category = categories.filter { $0.level == 1 }[indexPath.item]
            onCategorySelected?(category)
            
        } else if indexPath.section == 1 {
            
            let category = categories.filter { $0.level == 2 }[indexPath.item]
            onCategorySelected?(category)
            
        } else {
            
            let category = categories.filter { $0.level == 3 }[indexPath.item]
            onCategorySelected?(category)
            
        }
        
        
        dismiss(animated: true)
        
        
    }

}
