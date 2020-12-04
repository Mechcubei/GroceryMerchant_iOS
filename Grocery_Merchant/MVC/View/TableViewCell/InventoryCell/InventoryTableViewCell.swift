//
//  InventoryTableViewCell.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    
    //MARK:- OUTLETS
    @IBOutlet var lblProduct: UILabel!
    @IBOutlet var txtQty: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var txtUnit: UITextField!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var viewWeight: LBZSpinner1!
    @IBOutlet var viewAllCell: DesignableView!
    
//    var Weight = ""
//    var spinnerName = ""
//    var arrWeight = ["Kg","Ltr"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if viewWeight.selectedIndex == LBZSpinner.INDEX_NOTHING{
//            spinnerName = "Weight"
//            viewWeight.delegate = self
//            viewWeight.updateList(arrWeight)
//            viewWeight.text = ""
//        }
    }
//    func spinnerChoose1(_ spinner: LBZSpinner1, index: Int, value: String) {
//        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
//        Weight = value
//    }
    
}
