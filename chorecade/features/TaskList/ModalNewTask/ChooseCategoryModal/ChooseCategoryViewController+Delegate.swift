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
        
    }

}
