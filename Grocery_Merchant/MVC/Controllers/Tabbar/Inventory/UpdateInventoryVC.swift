//
//  UpdateInventoryVC.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class UpdateInventoryVC: UIViewController {

   
    @IBOutlet var tblView: UITableView!
    @IBOutlet var heightTableview: NSLayoutConstraint!
    
    var categoryID:String?
    var arrMerchantInventoryList = [MerchantInventoryListStruct2]()
    var arrListInventory = [ListCategoryStruct2]()
    var arrSubcategoryComponentValue = [SubCategoryComponentValueStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.callApi()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    //MARK:- CALL API
    func callApi() {
        self.registerNibFileName()
        self.merchantInventoryList()
    }
    
    //MARK:- FUNC REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "InventoryTableViewCell")
    }
    
    //MARK:- MERCHANT INVENTORY LIST API
    func merchantInventoryList() {
        
        let params:[String:Any] = ["category_id":categoryID!]
        GetApiResponse.shared.getMerchantInventoryList(params: params) { (data:MerchantInventoryListStruct) in
            self.arrMerchantInventoryList = data.data
            print(data)
            self.tblView.reloadData()
        }
    }
    
    //MARK:- GET LIST INVENTORY API
    func listInventory() {
        
        let categoryId = categoryID!
        let params:[String:Any] = [
            "category_id":categoryId
        ]
        Loader.shared.showLoader()
        self.arrListInventory.removeAll()
             
        GetApiResponse.shared.getListInventory(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrListInventory = data.data
            self.tblView.reloadData()
        }
    }
    
    @objc func getPriceValue(_ textfield: UITextField) {
     
        self.arrMerchantInventoryList[textfield.tag].price = Int(textfield.text!)
    }
    
    @objc func getQuantityValue(_ textfield: UITextField) {
     
        self.arrMerchantInventoryList[textfield.tag].qty = Int(textfield.text!)
    }
    
    //MARK:- GET SUB CATEGORY LIST
    
    func addUpdateMarchantInventory() {
        
        var subcategoryArray = [[String:Any]]()
        for i in  0..<arrMerchantInventoryList.count {
            let dataDict1:[String:Any]   =
                [
                    "category_id":categoryID!,
                    "merchant_inventory_id":arrMerchantInventoryList[i].merchant_inventory_id!,
                    "price":arrMerchantInventoryList[i].price!,
                    "qty":arrMerchantInventoryList[i].qty!,
                    "weight_type":"Kg",
                    "grocery_inventory_id":arrMerchantInventoryList[i].grocery_inventory_id!
            ]
            subcategoryArray.append(dataDict1)
            print(subcategoryArray)
        }
        
        let dataDict:[String:Any] = ["data":subcategoryArray]
        let jsonData = try! JSONSerialization.data(withJSONObject:dataDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let params:[String:Any] = [  "product":jsonString!]
        GetApiResponse.shared.addUpdateMerchantInventory(params: params) { (data:SubcategoryaddedModel) in
            print(data)
            Utilities.shared.showAlert(title: "", msg: data.message!)
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnUpdateInventory(_ sender: Any) {
        self.addUpdateMarchantInventory()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMore(_ sender: Any) {
        let vc = ENUM_STORYBOARD<UnselectedInventoryVC>.tabbar.instantiativeVC()
        vc.categoriesIDs = categoryID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK:- EXTENTION TABLE VIEW
@available(iOS 13.0, *)
extension UpdateInventoryVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMerchantInventoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryTableViewCell", for: indexPath) as! InventoryTableViewCell
        let url = URL(string: arrMerchantInventoryList[indexPath.row].image!)
        cell.imgProduct.kf.setImage(with: url)
        cell.lblProduct.text = arrMerchantInventoryList[indexPath.row].inventory_name
        
        // price texfield
        cell.txtPrice.tag = indexPath.row
        cell.txtPrice.delegate = self
        cell.txtPrice.addTarget(self, action: #selector(getPriceValue(_:)), for: .editingChanged)
        
        //quantiy texfield
        cell.txtQty.tag = indexPath.row
        cell.txtQty.delegate = self
        cell.txtQty.addTarget(self, action: #selector(getQuantityValue(_:)), for: .editingChanged)
        
        cell.txtPrice.text = "\(String(describing: arrMerchantInventoryList[indexPath.row].price!))"
        cell.txtQty.text = "\(String(describing: arrMerchantInventoryList[indexPath.row].qty!))"
        
        cell.viewAllCell.borderColor = arrMerchantInventoryList[indexPath.row].isSelected == true ? ENUMCOLOUR.themeColour.getColour() : UIColor.white
        cell.viewAllCell.borderWidth = arrMerchantInventoryList[indexPath.row].isSelected == true ?  2 :  0
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.arrMerchantInventoryList[indexPath.row].isSelected = arrMerchantInventoryList[indexPath.row].isSelected == true ? false : true
        tblView.reloadData()
    }
}
