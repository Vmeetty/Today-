//
//  UIManager.swift
//  Today
//
//  Created by user on 29.04.2022.
//

import Foundation
import UIKit
import ChameleonFramework
import RealmSwift

class UIManager {
    
    func settings(cell: ItemTableViewCell, items: Results<Item>?, indexPath: IndexPath, color: UIColor) -> ItemTableViewCell {
        guard let item = items?[indexPath.row] else {
            fatalError("No items at all")
            cell.textItemLabel.text = "No items yet"
        }
        cell.textItemLabel.text = item.title
        cell.indexPathForStar = indexPath
        let doneStatus = item.done
        cell.accessoryType = doneStatus ? .checkmark : .none
        let serious = item.serious
        let image = serious ? "star.fill" : "star"
        cell.starButton.setImage(UIImage(systemName: image), for: .normal)
        if let darkenColor = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
            cell.backgroundColor = darkenColor
            cell.bubbleView.backgroundColor = darkenColor
            let contrastColor = ContrastColorOf(darkenColor, returnFlat: true)
            cell.textItemLabel.textColor = contrastColor
            cell.starButton.tintColor = contrastColor
            cell.tintColor = contrastColor
        }
                
        return cell
    }
    
}
