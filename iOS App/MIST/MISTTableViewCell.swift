//
//  MISTTableViewCell.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/29/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class MISTTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundCardView.layer.cornerRadius = 4.0
        backgroundCardView.backgroundColor = UIColor.white
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
