//
//  ItemTableViewCell.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit
import SwipeCellKit

protocol ItemTableViewCellDelegate {
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath)
}

class ItemTableViewCell: SwipeTableViewCell {
    
    var itemCellDelegate: ItemTableViewCellDelegate?
    var indexPathForStar: IndexPath?

    @IBOutlet weak var textItemLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var starButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        itemCellDelegate?.setToSerious(self, didSelectStarButtonAt: indexPathForStar!)
    }
    
            
}
