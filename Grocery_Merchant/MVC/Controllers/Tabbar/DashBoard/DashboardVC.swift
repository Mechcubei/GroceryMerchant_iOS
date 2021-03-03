//
//  DashboardVC.swift
//  Grocery_Merchant
//
//  Created by osx on 27/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class DashboardVC: UIViewController {
    
    //MARK:- PROPERTIES
    var arrGetMerchantCategory = [GetMerchantCategoryStruct2]()
    
    //MARK:- OUTLETS
    @IBOutlet var dashboardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.getMerchantCategory()
        
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.dashboardCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
    }
    
    //MARK:- GET MERCHANT CATEGORY API
    func getMerchantCategory() {
        Loader.shared.showLoader()
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.getMerchantCategory(params: params) { (data:GetMerchantCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrGetMerchantCategory = data.data
            self.dashboardCollectionView.reloadData()
        }
    }
     
    //MARK:- ACTION BUTTONS
    @IBAction func btnAdd(_ sender: Any) {
        let vc = ENUM_STORYBOARD<CategoriesVC>.tabbar.instantiativeVC()
        vc.isCOmmingFrom = ENUM_IsCommingFrom.login
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- EXTENSION COLLECTION VIEW
@available(iOS 13.0, *)
extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGetMerchantCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.lblProduct.text = arrGetMerchantCategory[indexPath.row].category_name
        return cell
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

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       let vc = ENUM_STORYBOARD<UpdateInventoryVC>.tabbar.instantiativeVC()
       vc.categoryID = "\(String(describing: arrGetMerchantCategory[indexPath.row].id!))"
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

