//
//  MannualOrderDetailVC.swift
//  Grocery_Merchant
//
//  Created by osx on 12/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class MannualOrderDetailVC: UIViewController {

    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibFileName()
 
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "MannualDetailOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MannualDetailOrderTableViewCell")
    }
    //MARK:- TOTAL BILL
    func totalBill() {
        
        var productDict = [String:Any]()
        
        
        
        let params:[String:Any] = [
            "request_id":"",
            "user_id":"",
            "total":"",
            "product":""
        ]
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- EXTENSION TABLE VIEW
extension MannualOrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MannualDetailOrderTableViewCell", for: indexPath) as! MannualDetailOrderTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
