//
//  ApiServiceCall.swift
//  DeepDental
//
//  Created by Devoir Macbook on 21/12/19.
//  Copyright © 2019 Devoir Macbook. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD



@available(iOS 13.0, *)
class ApiService {
 
    
    static let shared = ApiService()
    
    
 func apiRequest2(api: String,method:HTTPMethod,parameters:[String:Any],completion: @escaping(Data?)->Void)   {
    
    SVProgressHUD.show()
    SVProgressHUD.setBackgroundColor(UIColor.clear)
    SVProgressHUD.setForegroundColor(UIColor.black)
    
    let baseUrl = AppConstants.baseURL
    guard let url = URL(string: baseUrl + api) else {
        completion(nil)
        return
    }
    if Connectivity.isConnectedToInternet() {
    }else{
        Utilities.shared.showAlertWithOK(title: "Attention!", msg: "The Internet connection appears to be offline.")
        SVProgressHUD.dismiss()
        return
    }
    print(parameters)
    var header:HTTPHeaders = [:]
    
    header["Accept"] = "application/json"

    Alamofire.request(url, method: method, parameters: parameters,encoding: URLEncoding.default,headers: header).responseJSON(completionHandler: { (response) in
        print(response)
        switch(response.result) {
        case .success(_):
            if let data = response.data{
                
                let json = JSON(data)
                let statusCode =  json["statusCode"].intValue
                if statusCode == 401 {
                   // Utilities.shared.showAlert(title: "Error", msg:json["message"].stringValue)
                    Utilities.shared.showAlertWithOK(title: "Alerts", msg: json["message"].stringValue)
                }else {
                    completion(data)

                }
            }
            
            SVProgressHUD.dismiss()
            break
        case .failure(_):
            completion(nil)
            SVProgressHUD.dismiss()
            let code = response.response?.statusCode
            print("error on service call1", response.error?.localizedDescription as Any)
            Utilities.shared.showAlertWithOK(title: "error(\(code ?? 0))", msg: "Something went wrong")
            break
        }
    })
}
    
    
    // Call Silent without loader
     func apiRequest(api: String,method:HTTPMethod,parameters:[String:Any],completion: @escaping(Data?)->Void)   {
        let baseUrl = AppConstants.baseURL
        guard let url = URL(string: baseUrl + api) else {
            completion(nil)
            return
        }
        if Connectivity.isConnectedToInternet() {
        }else{
            Utilities.shared.showAlertWithOK(title: "Attention!", msg: "Please check internet connection")
            return
        }
        
        let headers:[String:String] = [
                "Authorization": createHeaders()
        ]
        
        print(parameters)
        Alamofire.request(url, method: method, parameters: parameters,headers: headers).validate().responseJSON { response in
             print(response)
            switch(response.result) {
            case .success(_):
                                
                if let data = response.data{
                
                    completion(data)
                }
                
                
                break
            case .failure(_):
                completion(nil)
                let code = response.response?.statusCode
                print("error on service call1", response.error?.localizedDescription as Any)
                break
            }
        }
    }
    
    //MARK:- Multi-Part Api
    
    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    func apiRequestMulipart(api: String,urlFile:URL?,fileParamName:String?,parameters:[String:Any],completion: @escaping(Data?)->Void)   {
        
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor.black)
        
        let baseUrl = AppConstants.baseURL
        guard let url = URL(string: baseUrl + api) else {
            completion(nil)
            return
        }
        
        if Connectivity.isConnectedToInternet() {
        }else{
            Utilities.shared.showAlertWithOK(title: "Attention!", msg: "Please check internet connection")
            SVProgressHUD.dismiss()
            return
        }
        print(url.absoluteString)
        var headers:[String:String] = [:]
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"){
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        headers["Accept"] = "application/json"
        
        var itemData:Data?
        
        do{
            if let file = urlFile{
                itemData = try Data(contentsOf: file)
            }
        }catch{
            print("No Image")
        }
        let fileType = urlFile?.pathExtension
        let fileName = urlFile?.lastPathComponent
        
        //filename
        Alamofire.upload(
            multipartFormData: { (multipartFormData) in
                if let file = itemData{
                    multipartFormData.append(file, withName: fileParamName!, fileName: fileName!, mimeType: fileType!)
                }
                for (key, value) in parameters {
                    multipartFormData.append("\(value as! String)".data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
            to : url,
            method: .post, headers: headers){ (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        if Progress.fractionCompleted == 1.0{
                            SVProgressHUD.dismiss()
                        }
                    })
                    upload.responseJSON { response in
                        if let JSON = response.result.value {
                            SVProgressHUD.dismiss()
                            print("Response : ",JSON)
                            completion(response.data)
                        }
                    }
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    completion(nil)
                    print(encodingError)
                    Utilities.shared.showAlertWithOK(title: "Attension", msg: "Unable to connect please try again later")
                }
        }
    }
    
}
