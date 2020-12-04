//
//  ApiResponse.swift
//  DeepDental
//
//  Created by Devoir Macbook on 21/12/19.
//  Copyright © 2019 Devoir Macbook. All rights reserved.
//

import UIKit
import Alamofire

@available(iOS 13.0, *)
class GetApiResponse: UIViewController {
    
    static let shared = GetApiResponse()
    
    
    //MARK:- GenericsFunction
    
    @available(iOS 13.0, *)
    func getDataAll<T: Decodable>(api:String,parameters:[String:Any],method:HTTPMethod = .post,completion: @escaping(T)->())  {
        ApiService.shared.apiRequest2(api: api, method: method, parameters: parameters) { (data) in
            guard let data = data else { return }
            do{
                let res = try JSONDecoder().decode(T.self, from: data)
                completion(res)
            }catch{
                print("Error on parsing")
            }
        }
    }
    
    @available(iOS 13.0, *)
    func getDataAllSilent<T: Decodable>(api:String,parameters:[String:Any],method:HTTPMethod = .post,completion: @escaping(T)->())  {
        ApiService.shared.apiRequest(api: api, method: method, parameters: parameters) { (data) in
            
            guard let data = data else { return }
            do{
                let res = try JSONDecoder().decode(T.self, from: data)
                completion(res)
            }catch{
                print("Error on parsing")
            }
        }
    }
    
    func callApiMultiPartData<T: Decodable>(api:String,fileURL:URL?,fileParamName:String?,parameters:[String:Any],completion: @escaping(T?)->())  {
        ApiService.shared.apiRequestMulipart(api: api, urlFile: fileURL, fileParamName: fileParamName, parameters: parameters) { (data) in
            guard let data = data else { return }
            do{
                let res = try JSONDecoder().decode(T.self, from: data)
                completion(res)
            }catch{
                completion(nil)
                print("Error on parsing")
            }
        }
    }
    
    
    //MARK:- Smart Api
    
    func sendOtp<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAll(api: "send-otp",parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    
    func verifyOtp<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAll(api: "verify-otp-send",parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    
    func getCategory<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "get_category", parameters: params, method: .get) { (data: T) in
            completion(data)
        }
    }
    func getListInventory<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "get_inventory", parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    func addUpdateMerchantInventory<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "update_marchent_inventory", parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    func getMerchantCategory<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "get_merchant_category", parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    func getMerchantInventoryList<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "get_marchent_inventory", parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    func merchantSignUp<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "merchant_sign_up", parameters: params, method: .post) { (data: T) in
            completion(data)
        }
    }
    func bannerList<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "banner_list",parameters: params) { (data: T) in
            completion(data)
        }
    }
    func merchantOrder<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "merchants_order",parameters: params) { (data: T) in
            completion(data)
        }
    }
    func getMerchantUnselectedInventory<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "get_merchant_unselected_inventory",parameters: params) { (data: T) in
            completion(data)
        }
    }
    
    func merchantOrderView<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "merchants_order_view",parameters: params) { (data: T) in
            completion(data)
        }
    }
    
    func orderStatus<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "order_status",parameters: params) { (data: T) in
            completion(data)
        }
    }
    
    func totalBill<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "total_bill",parameters: params) { (data: T) in
            completion(data)
        }
    }
    func getCancellations<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
        GetApiResponse.shared.getDataAllSilent(api: "cancellations",parameters: params) { (data: T) in
            completion(data)
        }
    }
    func orderCancelationReason<T: Decodable>(params:[String:Any],completion: @escaping(T)->()) {
          GetApiResponse.shared.getDataAllSilent(api: "order_cancel",parameters: params) { (data: T) in
              completion(data)
          }
      }
}

