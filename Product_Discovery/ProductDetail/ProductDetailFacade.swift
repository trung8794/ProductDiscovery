//
//  ProductDetailFacade.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation

class ProductDetailFacade{
    func getProductDetail(sku: String, completion: ((_ data: ProductDTO) -> ())?, error: ((_ error: String) -> ())? = nil){
        let urlStr = "https://listing-stg.services.teko.vn/api/products/\(sku)"
        
        AppUtils.callCustomApi(urlStr, completeAction: { (resultJson) in
            let result = BaseResultDetail(json: resultJson)
            let product = result.product
            
            if let complete = completion{
                complete(product)
            }
            
        }) { (errorStr) in
            if let err = error{
                err(errorStr)
            }
        }
    }
}
