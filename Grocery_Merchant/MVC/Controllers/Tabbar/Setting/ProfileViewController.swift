//
//  ProfileViewController.swift
//  Grocery_Merchant
//
//  Created by Amandeep tirhima on 23/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var  txtStoreNAme: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblName: UILabel!
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- Api
    
    func setData(storeName:String, firstName:String, lastName:String, email:String, phonenumber:String){
        self.lblName.text = ""
        self.btnProfile.setImage(UIImage(named: ""), for: .normal)
        self.txtStoreNAme.text = storeName
        self.txtFirstName.text = firstName
        self.txtLastName.text = lastName
        self.txtEmail.text = email
        self.txtPhoneNumber.text = phonenumber
        
    }
    
    //MARK:- Actions
    @IBAction func  back(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ProfilePicAction(_ sender: Any) {
    }
        
    @IBAction func submitAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
