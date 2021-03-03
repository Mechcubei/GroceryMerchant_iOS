//
//  CurrentOrdersVC.swift
//  Grocery_Merchant
//
//  Created by osx on 22/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class CurrentOrdersVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblNoDataFound: UILabel!
    
    //MARK:- LOCAL VARIABLES
    var arrCurrentOrder = [CurrentOrderStruct2]()
    var selectedIndex = 0
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.pullToRefresh()
        
      }
    override func viewWillAppear(_ animated: Bool) {
     
        NotificationCenter.default.addObserver(self, selector: #selector(callApi(notification:)), name: NSNotification.Name(rawValue: "orderType"), object:nil)
    }
         
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "CurrentOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderTableViewCell")
        
    }
    //MARK:- REFRESH TABLEVIEW
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.darkGray
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tblView.addSubview(refreshControl!)
    }
    
    @objc func refresh() {
        self.selectOrder(index: self.selectedIndex)
        refreshControl?.endRefreshing()
        tblView.reloadData()
    }
    
    @objc func  callApi(notification:Notification){
        let type = notification.userInfo!["type"] as! Int
        self.selectOrder(index: type)
    }
    
    func selectOrder(index:Int) {
        self.arrCurrentOrder.removeAll()
        
        self.selectedIndex = index
        
        switch index {
            
        case 0:
            self.merchantOrder(status: "all")
            
        case 1:
            self.merchantOrder(status: "pending")
            
        case 2:
            self.merchantOrder(status: "accepted")
            
        case 3:
            self.merchantOrder(status: "in-process")
            
        case 4:
            self.merchantOrder(status: "ongoing")
            
        default:
            ""
        }
        
        self.tblView.reloadData()
    }
    
    //MARK:- MERCHANT ORDER VIEW API
    func merchantOrder(status:String) {
        
        let params:[String:Any] = ["status":status]
        Loader.shared.showLoader()
        GetApiResponse.shared.merchantOrder(params: params) { (data:CurrentOrderStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrCurrentOrder = data.data
            
            if self.arrCurrentOrder.count == 0 {
                self.lblNoDataFound.isHidden = false
            } else {
                self.lblNoDataFound.isHidden = true
            }
            
            self.tblView.reloadData()
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- EXTENSION TABLEVIEW VIEW

@available(iOS 13.0, *)
extension CurrentOrdersVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return arrCurrentOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentOrderTableViewCell", for: indexPath) as! CurrentOrderTableViewCell
        cell.lblOrderId.text = "Order ID: \(String(describing: arrCurrentOrder[indexPath.row].id!))"
        cell.lblOrderNo.text = arrCurrentOrder[indexPath.row].order_number
        cell.lbltotal.text = "\(String(describing: arrCurrentOrder[indexPath.row].total!))"
        cell.lblCreatedAt.text = arrCurrentOrder[indexPath.row].created_at
        cell.lblpending.text = arrCurrentOrder[indexPath.row].payment_type
        cell.lblStatus.text = arrCurrentOrder[indexPath.row].status
        cell.imgPro.cornerRadius = cell.imgPro.frame.size.width/2
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard arrCurrentOrder[indexPath.row].order_type == "grocery_image" else {
            
            let vc = ENUM_STORYBOARD<OrderDetailListVC>.tabbar.instantiativeVC()
            vc.orderId = arrCurrentOrder[indexPath.row].id!
            vc.status = arrCurrentOrder[indexPath.row].status!
            self.navigationController?.pushViewController(vc, animated: true)
    
            return
        }
        
        let vc = ENUM_STORYBOARD<OrderDetailVC>.tabbar.instantiativeVC()
        vc.orderId = arrCurrentOrder[indexPath.row].id!
        vc.status = arrCurrentOrder[indexPath.row].status!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
