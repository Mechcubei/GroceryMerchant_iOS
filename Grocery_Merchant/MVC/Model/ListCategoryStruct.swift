//
//  ListCategoryStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 17/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct ListCategoryStruct: Codable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data: [ListCategoryStruct2]
    
    enum CodingKeys: String, CodingKey {
        case statusCode, message
        case hasData = "has_data"
        case data
    }
}

struct ListCategoryStruct2: Codable {
    let categoryID: Int?
    let categoryName: String?
    let categoryImage: String?
    var isSelected:Bool = false
    
    let inventoryName: String?
    let image: String?
    let groceryInventoryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case categoryName = "category_name"
        case categoryImage = "category_image"
        
        
        case inventoryName = "inventory_name"
        case groceryInventoryID = "grocery_inventory_id"
        case image
        
    }
}
struct SubcategoryaddedModel: Codable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data: ListCategoryStruct2?
    
    enum CodingKeys: String, CodingKey {
        case statusCode, message
        case hasData = "has_data"
        case data
    }
}
