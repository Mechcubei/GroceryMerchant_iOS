//
//  SignUpVC.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GooglePlaces

@available(iOS 13.0, *)
class SignUpVC: UIViewController,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate,ImagePickerDelegate {
   
    //MARK:- OUTLETS
    @IBOutlet var txtGroceryName: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtGstinNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtAddLocation: UITextField!
    @IBOutlet var imgUpload: UIImageView!
    
    //MARK:- LOCAL VARIABLES
    var lat:Double?
    var long:Double?
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    //MARK:- FUNC SIGN UP API
    //    func editProfile() {
    //        Loader.shared.showLoader()
    //        let params:[String:Any] = ["grocery_name":txtGroceryName.text ?? "","first_name":txtFirstName.text ?? "","last_name":txtLastName.text ?? "","gst_number":txtGstinNumber.text ?? ""]
    //        GetApiResponse.shared.merchantSignUp(params: params) { (data:RegisterStruct) in
    //            Loader.shared.stopLoader()
    //            print(data)
    //            guard data.statusCode == 200 else {
    //                Utilities.shared.showAlert(title: "", msg: .mesdatasage!)
    //                return
    //            }
    //
    //            let vc =  ENUM_STORYBOARD<CategoriesVC>.tabbar.instantiativeVC()
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //
    //    }
    
    func merchantSignUp() {
        
        var parameters = [String:Any]()
        parameters = [
            "grocery_name":txtGroceryName.text ?? "",
            "first_name":txtFirstName.text ?? "",
            "last_name":txtLastName.text ?? "",
            "gst_number":txtGstinNumber.text ?? "",
            "latitude":lat!,
            "longitude":long!,
            "address":txtAddLocation.text ?? ""
        ]
        
        let headers:[String:String] = [
            "Authorization": createHeaders()
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // for single image
            let imageData = self.imgUpload.image!.jpegData(compressionQuality: 0.6)
            multipartFormData.append(imageData!, withName: "image", fileName: "file.png", mimeType: "image/png")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        },usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
          
          to: "http://134.209.157.211/Carrykoro/public/api/merchant_sign_up",
          method: .post,
          headers: headers
            )
            
        { (result) in
            switch result {
                
            case .success(let upload, _,_ ):
                Loader.shared.showLoader()
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response)
                    Loader.shared.stopLoader()
                    let vc = ENUM_STORYBOARD<CategoriesVC>.tabbar.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                
            }
        }
    }
    
    //MARK:- VALIDATIONS
    func valid() -> Bool{
        
        let valid = Validations.shareInstance.validateSignUp(groceryName: txtGroceryName.text ?? "", firstName: txtFirstName.text ?? "", lastName: txtLastName.text ?? "", gstNumber: txtGstinNumber.text ?? "", address: txtAddLocation.text ?? "")
        
        switch valid {
            
        case .success:
            
            return true
            
        case .failure(let error):
            
            Toast.show(text: error, type: .error)
            
            return false
        }
    }
    // imagePi8cker  delegate  methods
       func didSelect(image: UIImage?) {
           self.imgUpload.image = image
          // self.arrImg.append(image!)
           
       }
    
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        guard valid() else { return }
        self.merchantSignUp()
    }
    
    @IBAction func btnAddLocation(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
    @IBAction func btnAddGroceyImage(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
 //MARK:- Place picker delegate methods
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.lat = place.coordinate.latitude
        self.long = place.coordinate.longitude
        self.txtAddLocation.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      dismiss(animated: true, completion: nil)
    
    }
}
