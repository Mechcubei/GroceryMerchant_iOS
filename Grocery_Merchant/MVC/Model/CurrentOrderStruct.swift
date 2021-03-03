//
//  CurrentOrderStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 22/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

// MARK: - CurrentOrderStruct
struct CurrentOrderStruct: Codable {
    let statusCode: Int?
    let message: String?
    let hasData: Bool?
    let data: [CurrentOrderStruct2]
}

// MARK: - Datum
struct CurrentOrderStruct2: Codable {
    let id, userID, driverID, couponID: Int?
    let order_number: String?
    let addressID,delivery_charge, assigned_grocery: Int?
    let status, payment_type: String?
    let gst, total,subTotal: Double?
    let order_type, created_at: String?
    let updated_at: String?
    let req_items: [ReqItem]?
    let req_items_img: [ReqItemImg]?
    
}

// MARK: - ReqItem
struct ReqItem: Codable {
    let request_id, assignedGrocery, inventoryID: Int?
    let price,quantity: Double?

}

// MARK: - ReqItem
struct ReqItemImg: Codable {

}

