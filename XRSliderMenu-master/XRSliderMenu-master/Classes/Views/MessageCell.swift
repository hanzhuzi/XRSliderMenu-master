//
//  MessageCell.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/24.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.headImageView.layer.masksToBounds = true
        self.headImageView.layer.cornerRadius = 45.0 * 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
