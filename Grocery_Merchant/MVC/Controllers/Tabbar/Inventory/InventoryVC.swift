//
//  InventoryVC.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class InventoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    //MARK:- ACTION BUTTON
    @IBAction func btnUpdateInventory(_ sender: Any) {
        let vc = ENUM_STORYBOARD<UpdateInventoryVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddInventory(_ sender: Any) {
        let vc = ENUM_STORYBOARD<AddInventoryVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
    }
    
}
