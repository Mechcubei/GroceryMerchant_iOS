//
//  PreviewImageVC.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class PreviewImageVC: UIViewController {

    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.cornerRound(radius: 20, clipBounds: true)
 
    }
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
