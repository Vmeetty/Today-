//
//  ItemTableViewCell.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit

protocol ItemTableViewCellDelegate {
    func setToSerious(_ cell: ItemTableViewCell) -> UIImage?
}

class ItemTableViewCell: UITableViewCell {
    
    var delegate: ItemTableViewCellDelegate?

    @IBOutlet weak var textItemLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var starButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        let image = delegate?.setToSerious(self)
        starButton.setImage(image, for: .normal)
    }
    
}
