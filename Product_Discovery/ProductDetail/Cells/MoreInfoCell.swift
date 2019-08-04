//
//  MoreInfoCell.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/4/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class MoreInfoCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
