//
//  ItemTableViewCell.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit

protocol ItemTableViewCellDelegate {
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath)
}

class ItemTableViewCell: UITableViewCell {
    
    var delegate: ItemTableViewCellDelegate?
    var indexPathForStar: IndexPath?

    @IBOutlet weak var textItemLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var starButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        delegate?.setToSerious(self, didSelectStarButtonAt: indexPathForStar!)
//        starButton.setImage(image, for: .normal)
        print("starButtonPressed ->")
    }
    
}
