//
//  MerchantInventoryListStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 28/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct MerchantInventoryListStruct:Decodable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data:[MerchantInventoryListStruct2]
}

struct MerchantInventoryListStruct2:Decodable {
    
    var category_id,
    grocery_inventory_id,
    merchant_inventory_id,
    qty,
    price,
    marchent_user_id: Int?
    var isSelected:Bool? = false
    let category_name,inventory_name,image,weight_type:String?
    
}
