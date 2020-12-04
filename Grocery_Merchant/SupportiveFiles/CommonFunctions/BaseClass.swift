//
//  BaseClass.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class BaseClass: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
