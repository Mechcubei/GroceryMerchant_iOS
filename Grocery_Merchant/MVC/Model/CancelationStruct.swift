//
//  CancelationStruct.swift
//  Grocery_Merchant
//
//  Created by osx on 02/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import Foundation

struct CancelationStruct:Decodable {
    let statusCode:Int?
    let message:String?
    let has_data:Bool?
    let data:[CancelationStruct2]
    
}
struct CancelationStruct2:Decodable {
    let id:Int?
    let comment:String?
}
