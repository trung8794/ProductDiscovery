//
//  ProductCell.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var lblSellPrice: UILabel!
    
    @IBOutlet weak var disCountContainerView: UIView!
    @IBOutlet weak var discountView: CustomGradientView!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    
    // MARK: Lets
    let DEFAULT_IMG = "small"
    
    var cacheImageForCell: ((_ image: UIImage) -> ())?
    
    // MARK: - Life Circles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: - Functions
    func configCell(_ data: ProductDTO){
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        // Clear data for reloading new Cell cause of Register
        clearOldData()
        
        // ImageProduct and check Caching Image
        if data.cachedImages.count > 0{
             self.imgProduct.image = data.cachedImages[0]
        }else{
            var urlImage = ""
            for item in data.images{
                if item.url.value() != ""{
                    urlImage = item.url.value()
                    break
                }
            }
            loadImageAsync(urlImage)
        }
        
        // Name
        lblProductName.text = data.displayName.value().isEmpty ? data.name.value() : data.displayName.value()
        
        // Sell Price
        if data.price.sellPrice.value() != ""{
             priceView.isHidden = false
            lblSellPrice.text = data.price.sellPrice.value()
        }else{
            priceView.isHidden = true
        }
        
        // Don't know which tag use to show percent of Discout, So disCountView will be Hiden
        discountView.isHidden = true
        
        // oldPrice
        if data.price.supplierSalePrice.value() != ""{
            discountView.isHidden = false
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: data.price.supplierSalePrice.value())
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            lblOldPrice.attributedText = attributeString
        }else{
            discountView.isHidden = true
        }
        
    }
    
    
    func clearOldData(){
        imgProduct.image = UIImage(named: DEFAULT_IMG)
        lblProductName.text = nil
        lblSellPrice.text = nil
        lblOldPrice.text = nil
        lblOldPrice.attributedText = nil
        lblDiscount.text = nil
    }
    
    
    func loadImageAsync(_ urlStr: String){
        guard let url = URL(string: urlStr ) else{
            self.imgProduct.image = UIImage(named: DEFAULT_IMG)
            return
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if data != nil{
                    self.imgProduct.image =  UIImage(data: data!)
                    if let cachImage = self.cacheImageForCell{
                        cachImage(self.imgProduct.image ?? UIImage(named: self.DEFAULT_IMG)!)
                    }
                }else{
                    self.imgProduct.image = UIImage(named: self.DEFAULT_IMG)
                }
            }
        }
    }
}
