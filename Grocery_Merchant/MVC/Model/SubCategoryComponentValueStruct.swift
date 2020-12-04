//
//  SubCategoryComponentValueStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 20/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

class SubCategoryComponentValueStruct : NSObject {
    var price:String = ""
    var quantity:String = ""
    var weight:String = ""
    var isSelected:Bool = false
    
    init(price:String, quantity:String, weight:String) {
        self.price = price
        self.quantity = quantity
        self.weight = weight
    }
}
