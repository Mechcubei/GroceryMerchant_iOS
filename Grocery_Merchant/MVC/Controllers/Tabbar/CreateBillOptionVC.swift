//
//  CreateBillOptionVC.swift
//  Grocery_Merchant
//
//  Created by osx on 30/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class CreateBillOptionVC: UIViewController {
    
    var requestID:Int?
    var UserID:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnChooseFromImage(_ sender: Any) {
        
        let vc = ENUM_STORYBOARD<UploadPhotoVC>.tabbar.instantiativeVC()
        vc.requestID = requestID
        vc.UserID = UserID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnChooseFromMenu(_ sender: Any) {
        
        let vc = ENUM_STORYBOARD<MannualOrderDetailVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
