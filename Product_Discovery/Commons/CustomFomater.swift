//
//  CustomFomater.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation
class CustomFomater {
    static func formatIntNumber(value: Int) -> String? {
        return formatIntNumber(value: Int64(value))
    }
    
    static func formatIntNumber(value: Int64) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "."
        return numberFormatter.string(from: NSNumber(value: value))
    }
}
