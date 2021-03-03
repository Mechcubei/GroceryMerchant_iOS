//
//  MerchantOrderViewStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 29/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

// MARK: - MerchantOrderViewStruct
struct MerchantOrderViewStruct: Codable {
    let statusCode: Int?
    let message: String?
    let has_data: Bool?
    let data: [MerchantOrderViewStruct2]

}

// MARK: - MerchantOrderViewStruct2
struct MerchantOrderViewStruct2: Codable {
    let id, user_id, driver_id, coupon_id: Int?
    let order_number: String?
    let address_id, delivery_charge, assigned_grocery: Int?
    let status, payment_type: String?
    let gst,total,sub_total: Double?
    let order_type, created_at, updated_at: String?
    let order_images:[OrderImage]?
    let addressinfo: [Addressinfo]
    let userinfo: [Info]
    let merchants: [Merchant]

}

// MARK: - Addressinfo
struct Addressinfo: Codable {
    let latitude, longitude, address: String?
}

// MARK: - Info
struct Info: Codable {
    let id: Int?
    let email, first_name, last_name: String?
    let phone, country_code: Int?
    let image: String?
    let username: String?

}

// MARK: - Merchant
struct Merchant: Codable {
    let assigned_grocery: Int?
    let merchant_info: [MerchantInfo]
    let merchant_items: [MerchantItem]
}

// MARK: - MerchantItem
struct MerchantItem: Codable {
    let grocery_inventory_id, request_id, assigned_grocery, inventory_id: Int?
    let quantity, price: Int?
    let inventory_name: String?
    let image: String?

}
struct MerchantInfo: Codable {
    let id: Int?
    let email, first_name, last_name: String?
    let phone, country_code: Int?
    let image: String?
}
struct OrderImage:Codable {
    let gro_image :String?
}
