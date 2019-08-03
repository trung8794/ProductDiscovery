//
//  ProductCell.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var discountView: CustomGradientView!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(){
        // DisCount Label
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "20.000.000")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        lblOldPrice.attributedText = attributeString
    }
}
