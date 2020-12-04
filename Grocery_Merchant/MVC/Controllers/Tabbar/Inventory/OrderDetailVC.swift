//
//  OrderDetailVC.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class OrderDetailVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var orderDetailCollectionView: UICollectionView!
    @IBOutlet var stackAccpetDecline: UIStackView!
    @IBOutlet var stackCreateOrder: UIStackView!
    @IBOutlet var stacklabel: UIStackView!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var viewUpperHidden: DesignableView!
    @IBOutlet var lbl: UILabel!
    @IBOutlet var heightCollectionView: NSLayoutConstraint!
    @IBOutlet var reasonTblView: UITableView!
    
    //MARK:- LOCAL VARIABLES
    var orderId:Int?
    var status:String?
    var arrMerchantOrderList = [MerchantOrderViewStruct2]()
    var arrCancelation = [CancelationStruct2]()
    var cancelaltionOrderID:Int?
    
    
    var imageArray = ["http://134.209.157.211/Carrykoro/public/storage/grocery_upload_image/188/grocery_image160308687173.jpg","http://134.209.157.211/Carrykoro/public/storage/grocery_upload_image/188/grocery_image160308687173.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.merchantOrderView()
        self.setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registernibFileaNme()
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registernibFileaNme() {
        orderDetailCollectionView.register(UINib(nibName: "OrderDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderDetailCollectionViewCell")
        reasonTblView.register(UINib(nibName: "ReasonTableViewCell", bundle: nil), forCellReuseIdentifier: "ReasonTableViewCell")
    }
    
    //MARK:- MERCHANT ORDER VIEW
    func merchantOrderView() {
        let params:[String:Any] = ["order_id":orderId!]
        Loader.shared.showLoader()
        GetApiResponse.shared.merchantOrderView(params: params) { (data:MerchantOrderViewStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrMerchantOrderList = data.data
            self.orderDetailCollectionView.reloadData()
            self.view.layoutIfNeeded()
            self.heightCollectionView.constant = self.orderDetailCollectionView.contentSize.height
            self.view.layoutIfNeeded()
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
    
    
    //MARK:- SETUP UI
    func setUpUI() {
        
        self.viewHidden.isHidden = true
        self.viewUpperHidden.isHidden = true
        
        if status == "pending" {
            
            self.stackAccpetDecline.isHidden = false
            self.stackCreateOrder.isHidden = true
            self.stacklabel.isHidden = true
            
        } else if status == "in-process" {
            
            self.stackAccpetDecline.isHidden = true
            self.stackCreateOrder.isHidden = true
            self.stacklabel.isHidden = false
            self.lbl.startBlink()
            
        } else if status == "accepted" {
            
            self.stackAccpetDecline.isHidden = true
            self.stackCreateOrder.isHidden = false
            self.stacklabel.isHidden = true
            
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAccept(_ sender: Any) {
        self.orderStatus(Status: "accepted")
        self.stackAccpetDecline.isHidden = true
        self.stackCreateOrder.isHidden = false
    }
    @IBAction func btnDecline(_ sender: Any) {
        
        self.viewHidden.isHidden = false
        self.viewUpperHidden.isHidden = false
        
    }
    @IBAction func btnCreateBill(_ sender: Any) {
        
        let vc = ENUM_STORYBOARD<CreateBillOptionVC>.tabbar.instantiativeVC()
        vc.requestID = arrMerchantOrderList[0].id
        vc.UserID = arrMerchantOrderList[0].user_id
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
}
//MARK:- EXTENTION COLLECTION VIEW
@available(iOS 13.0, *)
extension OrderDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
        //        guard  arrMerchantOrderList[0].order_images.count >= 0  else {
        //            return 0
        //        }
        //        return arrMerchantOrderList[0].order_images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailCollectionViewCell", for: indexPath) as! OrderDetailCollectionViewCell
        
        
        // if   let imgUrl = arrMerchantOrderList[0].order_images[indexPath.item].gro_image {
        
        cell.imgView.sd_setImage(with: URL(string: imageArray[indexPath.item]), completed: nil)
        
        // }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: orderDetailCollectionView.frame.size.width/2, height: orderDetailCollectionView.frame.size.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ENUM_STORYBOARD<PreviewImageVC>.tabbar.instantiativeVC()
        vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .currentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

//MARK:- EXTENSION TABLEVIEW
@available(iOS 13.0, *)
extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCancelation.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonTableViewCell", for: indexPath) as! ReasonTableViewCell
        cell.lblReason.text = arrCancelation[indexPath.row].comment
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 50
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.cancelaltionOrderID = arrCancelation[indexPath.row].id!
        self.ReasonCancelation()
        
    }
}
