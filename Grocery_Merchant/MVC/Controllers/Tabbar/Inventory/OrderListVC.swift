//
//  OrderListVC.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class OrderListVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var whyCancelTableView: UITableView!
    @IBOutlet var viewWantToCancel: UIView!
    @IBOutlet var viewAllWantToCancel: UIView!
    @IBOutlet var viewWhyCancel: UIView!
    
    //VARIABLES
    var selectIndex:Int?
    let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibFileName()
        self.viewWantToCancel.roundCorners([.topLeft, .topRight], radius: 20)
        self.viewAllWantToCancel.isHidden = true
        self.viewWhyCancel.isHidden = true
  
    }
    //MARK:- FUNC REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableViewCell")
        whyCancelTableView.register(UINib(nibName: "WhyCanelTableViewCell", bundle: nil), forCellReuseIdentifier: "WhyCanelTableViewCell")
    }
    
    @objc func closeView(_ sender: UITapGestureRecognizer) {
        self.viewWhyCancel.isHidden = true
        self.viewAllWantToCancel.isHidden = true
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        
    }
    @IBAction func btnCancelOrder(_ sender: Any) {
        viewAllWantToCancel.isHidden = false
    }
    @IBAction func btnYes(_ sender: Any) {
        self.viewWhyCancel.isHidden = false
    }
    @IBAction func btnNo(_ sender: Any) {
        self.viewAllWantToCancel.isHidden = true
    }
    
}
//MARK:- EXTENTION TABLE VIEW
extension OrderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblView {
            return 10
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell", for: indexPath) as! OrderListTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WhyCanelTableViewCell", for: indexPath) as! WhyCanelTableViewCell
            if indexPath.row == selectIndex {
                cell.imgCheckMark.image = UIImage(named: "icons8-checkmark-64")
            } else {
                cell.imgCheckMark.image = .none
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblView {
            
        } else{
            selectIndex = indexPath.row
            let tapgestureRecognise = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
            self.viewWhyCancel.addGestureRecognizer(tapgestureRecognise)
        }
        self.whyCancelTableView.reloadData()
    }
}
