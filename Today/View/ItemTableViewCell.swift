//
//  ItemTableViewCell.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit

protocol ItemTableViewCellDelegate {
    func setToSeriousWith(_ title: String)
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
        delegate?.setToSeriousWith(sender.titleLabel?.text ?? "Button doesn't have a title")
    }
    
}
