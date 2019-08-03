//
//  ProductsDTO.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation
import EVReflection

class BaseResult: EVObject{
    var products = [ProductDTO]()
}

class ProductDTO: EVObject {
    var displayName: String?
    var sku: String?
    var name: String?
    var images = [ImageProductDTO]()
    var price = PriceDTO()
    var cachedImages =  [UIImage]()
}

class ImageProductDTO: EVObject {
    var url: String?
    var priority: String?
}

class PriceDTO: EVObject {
    var supplierSalePrice: String?
    var sellPrice: String?
}

