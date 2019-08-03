//
//  OptionalExtention.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation
extension Optional where Wrapped == String {
    func value(_ defaultValue: String = "") -> String {
        return self ?? defaultValue
    }
}
