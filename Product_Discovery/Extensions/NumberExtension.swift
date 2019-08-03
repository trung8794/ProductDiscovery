//
//  NumberExtension.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation
extension Int{
    var formatMoney: String? {
        return CustomFomater.formatIntNumber(value: self)
    }
}
