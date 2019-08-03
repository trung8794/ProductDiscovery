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
//        self.selectionStyle = UITableViewCell.SelectionStyle.none
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
        if data.price.sellPrice.value() != "" && Int(data.price.sellPrice.value())?.formatMoney.value() != ""{
             priceView.isHidden = false
            lblSellPrice.text = Int(data.price.sellPrice.value())?.formatMoney.value()
        }else{
            priceView.isHidden = true
        }
        
        // Discount view
        if let sellPrice = Int(data.price.sellPrice.value()), let oldPrice = Int(data.price.supplierSalePrice.value()){
            if oldPrice - sellPrice == 0{
                disCountContainerView.isHidden = true
            }else{
                // oldPrice
                if data.price.supplierSalePrice.value() != ""{
                    disCountContainerView.isHidden = false
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: data.price.supplierSalePrice.value())
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                    
                    lblOldPrice.attributedText = attributeString
                    
                    // count the percent of Discount
                    let percent = CGFloat(oldPrice - sellPrice) / CGFloat(oldPrice)
                    lblDiscount.text = "-\(Double(round(100*percent)/100))%"
                }else{
                    disCountContainerView.isHidden = true
                }
                
            }
        }else{
            disCountContainerView.isHidden = true
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
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    }
                }else{
                    self.imgProduct.image = UIImage(named: self.DEFAULT_IMG)
                }
            }
        }
    }
}
