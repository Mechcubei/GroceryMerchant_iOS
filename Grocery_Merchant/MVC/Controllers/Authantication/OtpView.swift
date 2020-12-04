//
//  OtpView.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import MKOtpView

class OtpView: UIView {

   
    @IBOutlet var viewOtpGet: MKOtpView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var btnContinue: DesignableButton!
    @IBOutlet var lblOtpTimer: UILabel!
    @IBOutlet var transparentView: UIView!
    
    var userOtp:Int?
    var phoneNumber:String?
    var  btnContinueTapped:((String,Int) -> Void)?
    var otpTimer = Timer()
    var totalTime = 0
    
//    static let  shared =  OtpView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.loadNib()
        self.setUpOTP()
        self.tapGestureToHideView(transparentView)
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.loadNib()
        self.setUpOTP()
        
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    //MARK:- TAP GESTURE
    func tapGestureToHideView(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeView))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
        
    @objc func removeView(){
        self.removeFromSuperview()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed("OTPView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    //MARK:- SET UP OTP
    func setUpOTP() {
        
        viewOtpGet.setVerticalPedding(pedding: 3)
        viewOtpGet.setHorizontalPedding(pedding: 15)
        viewOtpGet.setNumberOfDigits(numberOfDigits: 5)
        viewOtpGet.setBorderWidth(borderWidth: 1.0)
        viewOtpGet.setBorderColor(borderColor: ENUMCOLOUR.themeColour.getColour())
        viewOtpGet.setCornerRadius(radius: 2)
        viewOtpGet.setInputBackgroundColor(inputBackgroundColor: UIColor.white)
        viewOtpGet.enableSecureEntries()
        
        viewOtpGet.onFillDigits = { number in
        print("input number is \(number)")
            self.userOtp = number
        }
        viewOtpGet.render()
    }
    
    @objc func update() {
        if(totalTime > 0) {
            totalTime = totalTime - 1
            print(totalTime)
            lblOtpTimer.text = String("OTP valid for \(totalTime) sec")
            //resendButn.setTitle("\(totalTime) Resend Otp", for: .normal)
        }
        else {
            otpTimer.invalidate()
            lblOtpTimer.text = ""
        }
    }
  
    //MARK:- ACTION BUTTON
    @IBAction func btnContinue(_ sender: Any) {
//        self.verifyOtp()
        self.btnContinueTapped?("",userOtp!)

    }
}
