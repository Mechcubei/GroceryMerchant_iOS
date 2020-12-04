//
//  SubCategoryStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 19/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct SubCategoryStruct:Decodable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data: SubCategoryStruct2
}
struct SubCategoryStruct2:Decodable {
}
