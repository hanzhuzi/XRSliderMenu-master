//
//  MyCell.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
