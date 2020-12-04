//
//  GetMerchantCategoryStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 27/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct GetMerchantCategoryStruct:Decodable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data:[GetMerchantCategoryStruct2]
    
}
struct GetMerchantCategoryStruct2:Decodable {
    let id:Int?
    let category_name:String?
}
