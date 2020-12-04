//
//  CurrentOrderTableViewCell.swift
//  Grocery_Merchant
//
//  Created by osx on 22/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class CurrentOrderTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet var imgPro: UIImageView!
    @IBOutlet var lblOrderNo: UILabel!
    @IBOutlet var lbltotal: UILabel!
    @IBOutlet var lblCreatedAt: UILabel!
    @IBOutlet var lblpending: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblOrderId: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
}
