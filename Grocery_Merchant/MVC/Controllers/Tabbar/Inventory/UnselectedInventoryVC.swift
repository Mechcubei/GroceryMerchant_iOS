//
//  UnselectedInventoryVC.swift
//  Grocery_Merchant
//
//  Created by osx on 27/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import Kingfisher

@available(iOS 13.0, *)
class UnselectedInventoryVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    
    //MARK:- LOCAL VARIABLES
    var categoriesIDs:String?
    var arrMerchantUnselectedInventory = [MerchantInventoryListStruct2]()
    var arrSubcategoryComponentValue = [SubCategoryComponentValueStruct]()
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMerchantUnselectedInventory()
        self.registerNibFileName()
    }
    
    //MARK:- UNSELECTED INVENTORY API
    func getMerchantUnselectedInventory() {
        let params:[String:Any] = ["category_id":categoriesIDs!]
        GetApiResponse.shared.getMerchantUnselectedInventory(params: params) { (data:MerchantInventoryListStruct) in
            print(data)
            self.arrMerchantUnselectedInventory = data.data
            
            
            self.setQuantityAndPriceArray(subArray: self.arrMerchantUnselectedInventory.count)
            self.tblView.reloadData()
        }
    }
    
    func setQuantityAndPriceArray(subArray:Int){
          for _ in 0..<subArray{
              self.arrSubcategoryComponentValue.append(SubCategoryComponentValueStruct(price: "", quantity: "", weight: ""))
              
          }
      }
    
    //MARK:- UPDATE MERCHANT INVENTORY LIST
    func addUpdateUnseletedMarchantInventory() {
        
        var subcategoryArray = [[String:Any]]()
        for i in  0..<arrMerchantUnselectedInventory.count {
            let dataDict1:[String:Any]   =
                [
                    "category_id":categoriesIDs!,
                    "merchant_inventory_id":"0",
                    "price":arrSubcategoryComponentValue[i].price,
                    "qty":arrSubcategoryComponentValue[i].quantity,
                    "weight_type":"Kg",
                    "grocery_inventory_id":arrMerchantUnselectedInventory[i].grocery_inventory_id!
            ]
            subcategoryArray.append(dataDict1)
            print(subcategoryArray)
        }
        
        let dataDict:[String:Any] = ["data":subcategoryArray]
        let jsonData = try! JSONSerialization.data(withJSONObject:dataDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let params:[String:Any] = [  "product":jsonString!]
        Loader.shared.showLoader()
        GetApiResponse.shared.addUpdateMerchantInventory(params: params) { (data:SubcategoryaddedModel) in
            print(data)
            Loader.shared.stopLoader()
            let vc = self.navigationController!.viewControllers.filter { $0 is MainVC }.first!
            self.navigationController!.popToViewController(vc, animated: true)
            Utilities.shared.showAlert(title: "", msg: data.message!)
        }
    }
            
    //MARK:- FUNC REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "InventoryTableViewCell")
    }
    
    @objc func getPriceValue(_ textfield: UITextField) {
        self.arrSubcategoryComponentValue[textfield.tag].price = textfield.text!
    }
        
    @objc func getQuantityValue(_ textfield: UITextField) {
        self.arrSubcategoryComponentValue[textfield.tag].quantity = textfield.text!
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func btnAddInventory(_ sender: Any) {
        self.addUpdateUnseletedMarchantInventory()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- EXTENSION TABLEVIEW
@available(iOS 13.0, *)
extension UnselectedInventoryVC:UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMerchantUnselectedInventory.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryTableViewCell", for: indexPath) as! InventoryTableViewCell
        cell.lblProduct.text = arrMerchantUnselectedInventory[indexPath.row].inventory_name
        
        // price texfield
        cell.txtPrice.tag = indexPath.row
        cell.txtPrice.delegate = self
        cell.txtPrice.addTarget(self, action: #selector(getPriceValue(_:)), for: .editingChanged)

        //quantiy texfield
        cell.txtQty.tag = indexPath.row
        cell.txtQty.delegate = self
        cell.txtQty.addTarget(self, action: #selector(getQuantityValue(_:)), for: .editingChanged)
                
        cell.txtPrice.text =  "\(String(describing: arrSubcategoryComponentValue[indexPath.row].price))"
        cell.txtQty.text =   "\(String(describing: arrSubcategoryComponentValue[indexPath.row].quantity))"
        
        // check selected status
        cell.viewAllCell.borderColor = arrMerchantUnselectedInventory[indexPath.row].isSelected == true ? ENUMCOLOUR.themeColour.getColour() : UIColor.white
        cell.viewAllCell.borderWidth = arrMerchantUnselectedInventory[indexPath.row].isSelected == true ?  2 :  0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.arrMerchantUnselectedInventory[indexPath.row].isSelected = arrMerchantUnselectedInventory[indexPath.row].isSelected == true ? false : true
        tblView.reloadData()
    }
}
