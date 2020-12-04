
//
//  SettingVC.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
 
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotification(_ sender: Any) {
        let vc = ENUM_STORYBOARD<NotificationVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
