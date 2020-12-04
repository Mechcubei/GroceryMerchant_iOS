//
//  AlertVC.swift
//  Grocery_Merchant
//
//  Created by osx on 30/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    @IBOutlet var tblView: UITableView!
    
    var arrName = ["Jonathan Cole send a order request to you.","Jonathan Cole send a order request to you.","Jonathan Cole send a order request to you.","Jonathan Cole send a order request to you.","Jonathan Cole send a order request to you.","Jonathan Cole send a order request to you.","Jonathan Cole send a order request to you."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        
    }
    
    //MARK:- FUNC REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "AlertTableViewCell", bundle: nil), forCellReuseIdentifier: "AlertTableViewCell")
    }
    
}
//MARK:- EXTENTION TABLE VIEW
extension AlertVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
        cell.lblName.text = arrName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.arrName.remove(at: indexPath.row)
            self.tblView.deleteRows(at: [indexPath], with: .middle)
        }
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
                  print("more button tapped")
            self.arrName.remove(at: indexPath.row)
            self.tblView.deleteRows(at: [indexPath], with: .middle)
              }
              delete.backgroundColor = UIColor.systemPink
        
        let cancel = UITableViewRowAction(style: .normal, title: "Cancel") { action, index in
                         print("more button tapped")
                     }
        cancel.backgroundColor = ENUMCOLOUR.themeColour.getColour()
        
        
        
        

        return [delete,cancel]

    }
}
