//
//  CategoriesVC.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class CategoriesVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var categoriesCollectionView: UICollectionView!
    @IBOutlet var heightCollectionview: NSLayoutConstraint!
    @IBOutlet var btnBack: UIButton!
    
    //MARK:- PROPERTIES
    var arrListCategories = [ListCategoryStruct2]()
    var arrSelectedData = [String]()
    var arrProductname = [String]()
    var isCOmmingFrom:ENUM_IsCommingFrom!
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CALL API
        self.callApi()
        
        //SET UP INITIAL VIEW
        self.initialView()
        
    }
    func initialView() {
        self.tabBarController?.tabBar.isHidden = true
        self.btnBack.isHidden = isCOmmingFrom == ENUM_IsCommingFrom.login ? false : true
    }
    
    //MARK:- Call API'S
    func callApi() {
        
        self.listCategory()
        self.registerNibFileName()
        
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        
        self.categoriesCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
    }
    //SET COLLECTIONVIEW HEIGHT DYNAMICALLY
     func setCollectionViewHeight() {
         DispatchQueue.main.async{
             self.categoriesCollectionView.reloadData()
             self.view.layoutIfNeeded()
             self.heightCollectionview.constant = self.categoriesCollectionView.contentSize.height
             self.view.layoutIfNeeded()
         }
     }
    
    //MARK:- GET LIST CATEGORY API's
    func listCategory() {
        let params:[String:Any] = ["":""]
        
        Loader.shared.showLoader()
        GetApiResponse.shared.getCategory(params: params){ (data: ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrListCategories = data.data
            self.setCollectionViewHeight()
            self.categoriesCollectionView.reloadData()
        }
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnNext(_ sender: Any) {
        
        self.arrSelectedData.removeAll(keepingCapacity: false)
        for i in 0..<arrListCategories.count {
            if arrListCategories[i].isSelected == true  {
                arrSelectedData.append("\(arrListCategories[i].categoryID!)")
                arrProductname.append("\(arrListCategories[i].categoryName!)")
                print("\(arrSelectedData)")
                print("\(arrProductname)")
            }
        }
        
        if arrSelectedData.isEmpty == false {
            let vc = ENUM_STORYBOARD<AddInventoryVC>.tabbar.instantiativeVC()
            vc.categoriesIDs = arrSelectedData
            vc.produnctName = arrProductname
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            Utilities.shared.showAlert(title: "Message", msg: "Please Select any one item")
        }
        self.categoriesCollectionView.reloadData()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
//MARK:- EXTENSTION COLLECTIONVIEW
@available(iOS 13.0, *)
extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        let url = URL(string: arrListCategories[indexPath.item].categoryImage!)
        cell.imgProduct.kf.setImage(with: url)
        cell.lblProduct.text = arrListCategories[indexPath.item].categoryName
        
        
        cell.backgroundColor = arrListCategories[indexPath.item].isSelected == true ?  UIColor.green  : UIColor.white
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.arrListCategories[indexPath.item].isSelected = arrListCategories[indexPath.item].isSelected == true ?  false : true
        self.categoriesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
