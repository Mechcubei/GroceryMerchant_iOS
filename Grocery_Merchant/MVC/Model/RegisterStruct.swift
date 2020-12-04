//
//  RegisterStruct.swift
//  GroceryUser
//
//  Created by osx on 31/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct RegisterStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:RegisterStruct2
}

struct RegisterStruct2:Decodable {
//    let country_code:Int?
//    let email:String?
//    let email_status:Int?
    let first_name:String?
//    let image:String?
    let last_name:String?
//    let phone:Int?
//    let phone_status:Int?
//    let user_id:Int?
}
