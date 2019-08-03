//
//  ProductListFacade.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation

class ProductListFacade{
    func getListProducts( keyWords: String = "", page: String = "1", limit: String = "20", completion: ((_ data: [ProductDTO]) -> ())?, error: ((_ error: String) -> ())? = nil){
        let urlStr = "https://listing-stg.services.teko.vn" +
            "/api/search/?channel=pv_online&visitorId=&q=\(keyWords)" +
        "&terminal=CP01&_page=\(page)&_limit=\(limit)"
        
        AppUtils.callCustomApi(urlStr, completeAction: { (resultJson) in
            let result = BaseResult(json: resultJson)
            let products = result.products
            
            if let complete = completion{
                complete(products)
            }
            
        }) { (errorStr) in
            if let err = error{
                err(errorStr)
            }
        }
    }
}
