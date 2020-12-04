//
//  AddInventoryVC.swift
//  Grocery_Merchant
//
//  Created by osx on 11/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class AddInventoryVC: UIViewController,UITextFieldDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblproductName: UILabel!
    
    //MARK:- Properties
    var arrListInventory = [ListCategoryStruct2]()
    var categoriesIDs = [String]()
    var arrSubCategory = [SubCategoryStruct2]()
    var price:String?
    var quantity:String?
    var arrSubcategoryComponentValue = [SubCategoryComponentValueStruct]()
    var produnctName = [String]()
    var Weight = ""
    var spinnerName = ""
    var arrWeight = ["Kg","Ltr","Pkt"]
    
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.listInventory()
        
        self.setProductNameTitle(titleName: produnctName[0] )
        
        
    }
    //MARK:- FUNC REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "InventoryTableViewCell")
    }
    
    //MARK:- CLASS EXTRA FUNCTIONS
    func setQuantityAndPriceArray(subArray:Int){
        for _ in 0..<subArray{
            
            self.arrSubcategoryComponentValue.append(SubCategoryComponentValueStruct(price: "", quantity: "", weight: ""))
            
        }
    }
    func setProductNameTitle(titleName:String) {
        
//        self.lblProductName.text = titleName
        self.lblproductName.text = titleName
        
    }
    func spinnerChoose1(_ spinner: LBZSpinner1, index: Int, value: String) {
        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
        Weight = value
    }
    
    //MARK:- GET LIST INVENTORY API
    func listInventory() {
        
        let categoryId = categoriesIDs[0]
        let params:[String:Any] = [
            "category_id":categoryId
        ]
        Loader.shared.showLoader()
        self.arrListInventory.removeAll()
        self.arrSubcategoryComponentValue.removeAll()
        
        GetApiResponse.shared.getListInventory(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrListInventory = data.data
            self.setQuantityAndPriceArray(subArray: self.arrListInventory.count)
            self.tblView.reloadData()
        }
    }
    
    //MARK:- GET SUB CATEGORY LIST
    func addSubcategory(){
        
        arrListInventory = arrListInventory.filter{ $0.isSelected == true }
  
        arrSubcategoryComponentValue = arrSubcategoryComponentValue.filter{ $0.isSelected == true}
        print(arrListInventory)
        
        var subcategoryArray = [[String:Any]]()
        for i in  0..<arrListInventory.count {
            let dataDict1:[String:Any]   =
                [
                    "category_id":categoriesIDs[0],
                    "merchant_inventory_id":"0",
                    "price":arrSubcategoryComponentValue[i].price,
                    "qty":arrSubcategoryComponentValue[i].quantity,
                    "weight_type":Weight,
                    "grocery_inventory_id":"\(arrListInventory[i].groceryInventoryID!)"
            ]
            subcategoryArray.append(dataDict1)
        }
        
        let dataDict:[String:Any] = ["data":subcategoryArray]
        let jsonData = try! JSONSerialization.data(withJSONObject:dataDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let params:[String:Any] = [ "product":jsonString!]
        
        Loader.shared.showLoader()
        GetApiResponse.shared.addUpdateMerchantInventory(params: params) { (data:SubcategoryaddedModel) in
            print(data)
            
            self.categoriesIDs.removeFirst()
            self.produnctName.removeFirst()
            Loader.shared.stopLoader()
            guard self.categoriesIDs.count != 0 else  {

                if let viewController = self.navigationController?.viewControllers.first(where: {$0 is MainVC}) {
                    self.navigationController?.popToViewController(viewController, animated: false)
                }else {
                   
                    let vc = ENUM_STORYBOARD<MainVC>.tabbar.instantiativeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                Utilities.shared.showAlert(title: "", msg: data.message!)
                return
            }
            self.setProductNameTitle(titleName: self.produnctName[0])
            self.listInventory()
    
        }
    }
    
    @objc func getPriceValue(_ textfield: UITextField) {
        self.arrSubcategoryComponentValue[textfield.tag].price = textfield.text!
    }
    
    @objc func getQuantityValue(_ textfield: UITextField) {
        arrSubcategoryComponentValue[textfield.tag].quantity = textfield.text!
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddInventory(_ sender: Any) {
        self.addSubcategory()
    }
    @IBAction func btnAddMore(_ sender: Any) {
        let vc = ENUM_STORYBOARD<UnselectedInventoryVC>.tabbar.instantiativeVC()
//        vc.categoriesIDs = categoriesIDs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- EXTENTION TABLE VIEW
@available(iOS 13.0, *)
extension AddInventoryVC: UITableViewDelegate, UITableViewDataSource,LBZSpinnerDelegate1 {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListInventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryTableViewCell", for: indexPath) as! InventoryTableViewCell
        
        // set api data
        let url = URL(string: arrListInventory[indexPath.item].image!)
        cell.imgProduct.kf.setImage(with: url)
        cell.lblProduct.text = arrListInventory[indexPath.row].inventoryName
        
        cell.txtPrice.text = arrSubcategoryComponentValue[indexPath.row].price
        cell.txtQty.text =  arrSubcategoryComponentValue[indexPath.row].quantity
        
        // price texfield
        cell.txtPrice.tag = indexPath.row
        cell.txtPrice.delegate = self
        cell.txtPrice.addTarget(self, action: #selector(getPriceValue(_:)), for: .editingChanged)
                
        //quantiy texfield
        cell.txtQty.tag = indexPath.row
        cell.txtQty.delegate = self
        cell.txtQty.addTarget(self, action: #selector(getQuantityValue(_:)), for: .editingChanged)
        
        // check selected status
        cell.viewAllCell.borderColor = arrListInventory[indexPath.row].isSelected == true ? ENUMCOLOUR.themeColour.getColour() : UIColor.white
        cell.viewAllCell.borderWidth = arrListInventory[indexPath.row].isSelected == true ?  2 :  0
        
        //SETUP SPINNER
        if cell.viewWeight.selectedIndex == LBZSpinner.INDEX_NOTHING{
            spinnerName = "Weight"
            cell.viewWeight.delegate = self
            cell.viewWeight.updateList(arrWeight)
            cell.viewWeight.text = "Kg"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.arrListInventory[indexPath.row].isSelected = arrListInventory[indexPath.row].isSelected == true ? false : true
        self.arrSubcategoryComponentValue[indexPath.row].isSelected = arrSubcategoryComponentValue[indexPath.row].isSelected == true ? false : true
        self.tblView.reloadData()
    }
}
