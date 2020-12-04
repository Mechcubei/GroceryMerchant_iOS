//
//  LoginVC.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import CountryPickerView


@available(iOS 13.0, *)
class LoginVC: UIViewController,UIGestureRecognizerDelegate,CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    //MARK:- OUTLETS
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet var countryPickerView: CountryPickerView!
    
    //MARK:- PROPERTIES
    let setOtpView = OtpView()
    var countryPickView = CountryPickerView()
    var countryCode = ""
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCountryCode()
        
    }
    //MARK:- SETUP COUNTRY CODE UI
    func setUpCountryCode() {
        
        let country = countryPickView.selectedCountry.phoneCode
        print(country)
        countryCode = country
        countryPickerView.showCountryCodeInView = false
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.textColor = .black
        //countryPickerView.font = UIFont(name: "Roboto-Bold", size: 14.0)
        
    }
    
    //MARK:-SET UP OTP VIEW
    func setUpOtpView() {
        let setOtpView = OtpView.init(frame: self.view.frame)
        setOtpView.btnContinueTapped = { message,otp in
            print(otp)
            self.verifyOtp(otp: "\(otp)")
        }
        self.view.addSubview(setOtpView)
    }
    
    @objc func actionTapGesture(_sender: UITapGestureRecognizer) {
        self.setOtpView.isHidden = true
        //self.view.removeFromSuperview()
        self.viewHidden.isHidden = true
    }
    
    
    // MARK:- SEND OTP API's
    func sendOtp() {
        if let number = txtPhoneNumber.text {
            if number == ""{
                Utilities.shared.showAlert(title: "", msg: "Please enter your phone number")
                return
            }
            if number.count == 10 {
                let newString = countryCode.replacingOccurrences(of: "+", with: "", options: .literal, range: nil)
                let params:[String:Any] = ["phone_number":  txtPhoneNumber.text!,"user_role":"Merchant","country_code":newString]
                GetApiResponse.shared.sendOtp(params: params) { (data: LoginStruct) in
                    print(data)
                    if data.statusCode == 200 {
                        self.setUpOtpView()
                    } else {
                        print(data.message!)
                    }
                }
            } else {
                Utilities.shared.showAlert(title: "", msg: "Please enter correct phone number")
            }
        }
    }
    
    //MARK:- VERIFY-OTP API
    func verifyOtp(otp:String) {
        let newString = countryCode.replacingOccurrences(of: "+", with: "", options: .literal, range: nil)
        let params:[String:Any] = ["phone_number":txtPhoneNumber.text!,
                                   "user_role":"Merchant",
                                   "country_code":newString,
                                   "user_otp":otp,
                                   "device_type":"ios"
        ]
        
        GetApiResponse.shared.verifyOtp(params: params) { (data: LoginStruct) in
            print(data)
            
            if data.statusCode == 200 {
                UserDefaults.standard.set(data.data?.token, forKey: "token")
                if data.data?.first_name != "" && data.data?.last_name != "" {
                    
                    let vc = ENUM_STORYBOARD<MainVC>.tabbar.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    
                    let vc = ENUM_STORYBOARD<SignUpVC>.login.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            } else {
                self.setOtpView.isHidden = true
            }
        }
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.phoneCode)
        countryCode = country.phoneCode
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnLogin(_ sender: Any) {
        
        self.sendOtp()
        
    }
    @IBAction func btnOpenCountryPicker(_ sender: Any) {
        
    }
}

