//
//  ProductDetailViewController.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - Lets
    let productDetailFacade = ProductDetailFacade()
    
    // MARK: - Vars
    var skuValue: String?
//    var product = ProductDTO()

    
    // MARK: - Life Circles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
    }
    
    
    // MARK: - Inits
    func initData(){
        getProductDetail(_sku: self.skuValue.value())
    }
    
    
    // MARK: - Services
    func getProductDetail(_sku: String){
        productDetailFacade.getProductDetail(sku: _sku, completion: { (product) in
            
        self.fillImagesToCarousel(product.images.filter{$0.url.value() != ""})
            
        }) { (error) in
            
        }
    }
    
    // MARK: - Functions
    func fillImagesToCarousel(_ lstUrlImage: [ImageProductDTO]) {
        
    }

    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
