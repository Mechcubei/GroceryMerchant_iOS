//
//  ProfileModel.swift
//  Grocery_Merchant
//
//  Created by Amandeep tirhima on 27/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import Foundation

struct ProfileModel:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:DataStruct?
}

struct DataStruct:Decodable {
    let first_name,token,last_name: String?,userName:String?,store_name:String?,image:String?
    let category_list:Int?
}
