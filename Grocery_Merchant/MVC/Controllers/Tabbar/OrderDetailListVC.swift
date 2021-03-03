//
//  OrderDetailListVC.swift
//  Grocery_Merchant
//
//  Created by osx on 29/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
@available(iOS 13.0, *)
class OrderDetailListVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblGst: UILabel!
    @IBOutlet var lblDeliveryCharges: UILabel!
    @IBOutlet var lblAppliedCoupon: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var btnAccept: DesignableButton!
    @IBOutlet var btnDecline: DesignableButton!
    @IBOutlet var tblViewHeight: NSLayoutConstraint!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var viewUpperHidden: DesignableView!
    @IBOutlet var acceptHideButton: UIStackView!
    @IBOutlet var btnOrderReady: DesignableButton!
    @IBOutlet var orderreadyButton: UIStackView!
    @IBOutlet var lblInProgress: UILabel!
    @IBOutlet var inProcessStack: UIStackView!
    @IBOutlet var reasonTblView: UITableView!
    
    //MARK:- LOCAL VARIABLES
    var orderId:Int?
    var status:String?
    var arrMerchantOrderDetailList = [MerchantOrderViewStruct2]()
    var arrCancelation = [CancelationStruct2]()
    var cancelaltionOrderID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.merchantOrderView()
        self.setUpUI()
        
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        
        tblView.register(UINib(nibName: "OrderDetailListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailListTableViewCell")
        reasonTblView.register(UINib(nibName: "ReasonTableViewCell", bundle: nil), forCellReuseIdentifier: "ReasonTableViewCell")
        
    }
    //MARK:- SETUP UI
    func setUpUI() {
        
        self.viewHidden.isHidden = true
        self.viewUpperHidden.isHidden = true
        
        if status == "pending" {
            
            self.acceptHideButton.isHidden = false
            self.orderreadyButton.isHidden = true
            self.inProcessStack.isHidden = true
            
        } else if status == "in-process" {
            
            self.acceptHideButton.isHidden = true
            self.orderreadyButton.isHidden = true
            self.inProcessStack.isHidden = false
            self.lblInProgress.startBlink()
            
        } else if status == "accepted" {
            
            self.acceptHideButton.isHidden = true
            self.orderreadyButton.isHidden = false
            self.inProcessStack.isHidden = true
            
        }
    }
    
    //MARK:- SETUP MERCHANT DATA
    func setUpMerchantData(amount:Double,gst:Double,deliveryCharges:Int,appliedCoupon:Int,totalAmount:Double,deliveryAddress:String) {
        
        self.lblAmount.text = "\(amount)"
        self.lblGst.text = "\(gst)"
        self.lblDeliveryCharges.text = "\(deliveryCharges)"
        self.lblAppliedCoupon.text = "\(appliedCoupon)"
        self.lblTotalAmount.text = "\(totalAmount)"
        self.lblAddress.text = deliveryAddress
        
    }
    
    //MARK:- MERCHANT ORDER VIEW
    func merchantOrderView() {
        let params:[String:Any] = ["order_id":orderId!]
        Loader.shared.showLoader()
        GetApiResponse.shared.merchantOrderView(params: params) { (data:MerchantOrderViewStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            self.arrMerchantOrderDetailList = data.data
            
            self.tblView.reloadData()
            self.view.layoutIfNeeded()
            self.tblViewHeight.constant = self.tblView.contentSize.height
            self.view.layoutIfNeeded()
            self.setUpMerchantData(amount: self.arrMerchantOrderDetailList[0].sub_total!, gst: self.arrMerchantOrderDetailList[0].gst!, deliveryCharges: self.arrMerchantOrderDetailList[0].delivery_charge!, appliedCoupon: 0, totalAmount: self.arrMerchantOrderDetailList[0].total!, deliveryAddress: self.arrMerchantOrderDetailList[0].addressinfo[0].address ?? "")
        }
        
    }
    
    //MARK:- ORDER STATUS API
    func orderStatus(Status:String) {
        Loader.shared.showLoader()
        let params:[String:Any] = ["status":Status,"order_id":orderId!]
        GetApiResponse.shared.orderStatus(params: params) { (data:LoginStruct) in
            print(data)
            Loader.shared.stopLoader()
            let params = ["type": 0]
            NotificationCenter.default.post(name: Notification.Name("orderType"), object: nil, userInfo:params)
            Utilities.shared.showAlert(title: "", msg: data.message!)
        }
    }
    
    //MARK:- ORDER CANCELATION API
    func orderCancelation() {
        Loader.shared.showLoader()
        let params:[String:Any] = ["cancel_type":"pharmacy"]
        GetApiResponse.shared.getCancellations(params: params) { (data:CancelationStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrCancelation = data.data
            self.reasonTblView.reloadData()
            
        }
        
    }
    
    //MARK:- REASON ORDER CANCELATION API
    func ReasonCancelation() {
        
        Loader.shared.showLoader()
        let params:[String:Any] = ["order_id":orderId!,"cancel_comment_id":cancelaltionOrderID!]
        GetApiResponse.shared.orderCancelationReason(params: params) { (data:LoginStruct) in
            print(data)
            Loader.shared.stopLoader()
            if data.statusCode == 200 {
                
                if let vc = self.navigationController?.viewControllers.first(where: {$0 is MainVC}) {
                    self.navigationController?.popToViewController(vc, animated: false)
                }
            } else {
                
                Utilities.shared.showAlert(title: "Alert!", msg: data.message!)
            }
            
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnAccept(_ sender: Any) {
        
        self.orderStatus(Status: "accepted")
        self.acceptHideButton.isHidden = true
        self.orderreadyButton.isHidden = false
        
    }
    
    @IBAction func lblDeclaine(_ sender: Any) {
        
        self.viewHidden.isHidden = false
        self.viewUpperHidden.isHidden = false
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnYes(_ sender: Any) {
        
        self.viewUpperHidden.isHidden = true
        self.reasonTblView.isHidden = false
        self.orderCancelation()
        
    }
    @IBAction func btnNo(_ sender: Any) {
        
        self.viewHidden.isHidden = true
        self.viewUpperHidden.isHidden = true
    }
    @IBAction func btnOrderReady(_ sender: Any) {
        self.orderStatus(Status: "in-process")
        self.navigationController?.popViewController(animated: true)
        
    }
}
//MARK:- EXTENSION TABLEVIEW
@available(iOS 13.0, *)
extension OrderDetailListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblView {
            return arrMerchantOrderDetailList.count
        } else {
            return arrCancelation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tblView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailListTableViewCell", for: indexPath) as! OrderDetailListTableViewCell
            cell.lblProductName.text = "\(String(describing: arrMerchantOrderDetailList[indexPath.row].merchants[0].merchant_items[indexPath.row].inventory_name!))"
            cell.lblQty.text = "\(String(describing: arrMerchantOrderDetailList[indexPath.row].merchants[0].merchant_items[indexPath.row].quantity!))"
            cell.lblPrice.text = "\(String(describing: arrMerchantOrderDetailList[indexPath.row].merchants[0].merchant_items[indexPath.row].price!))"
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonTableViewCell", for: indexPath) as! ReasonTableViewCell
            cell.lblReason.text = arrCancelation[indexPath.row].comment
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblView {
            return 103
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.reasonTblView {
            self.cancelaltionOrderID = arrCancelation[indexPath.row].id!
            self.ReasonCancelation()
        }
    }
}
