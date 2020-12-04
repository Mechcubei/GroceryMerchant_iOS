//
//  OrderPagerViewVC.swift
//  Grocery_Merchant
//
//  Created by osx on 28/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class OrderPagerViewVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectnView: UICollectionView!
    @IBOutlet var lblNoDataFound: UILabel!
    
    //MARK:- LOCAL VARIABLES
    var selectedIndex = 0
    var arrNameCategories = ["ALL","PENDING","ACCEPTED","IN PROCESS","ON GOING"]
        
    //MARK:- SET UP PAGEVIEW CONTROLLER
     lazy var aboutSelfPVC: PageViewController = {
         let viewController = PageViewController(transitionStyle:
             UIPageViewController.TransitionStyle.scroll, navigationOrientation:
             UIPageViewController.NavigationOrientation.horizontal, options: nil)
                
        
         viewController.pages = {
             return [
                 getViewController(withIdentifier: "CurrentOrdersVC"),
                 getViewController(withIdentifier: "CurrentOrdersVC"),
                 getViewController(withIdentifier: "CurrentOrdersVC"),
                 getViewController(withIdentifier: "CurrentOrdersVC"),
                 getViewController(withIdentifier: "CurrentOrdersVC")
             ]
         }()
                         
         func getViewController(withIdentifier identifier: String) -> UIViewController{
             return UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: identifier)
         }
         return viewController
     }()
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.add(asChildViewController: self.aboutSelfPVC)
        self.aboutSelfPVC.delegateScroll = self
        self.registerNibFileName()
        self.selectOrderType(index: 0)
        
    
    }
        
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
                
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
        
    //MARK:- REGISTER NIB FILE NAME
       func registerNibFileName() {
           collectnView.register(UINib(nibName: "CurrentOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CurrentOrderCollectionViewCell")
       }
    
    
    func selectOrderType(index:Int){
        
        let params = ["type": index]
        NotificationCenter.default.post(name: Notification.Name("orderType"), object: nil, userInfo:params)
        self.selectedIndex = index
        self.collectnView.reloadData()
        
    }
    
    func scrollToIndex(index:Int) {
        self.collectnView?.scrollToItem(at: IndexPath(item: index, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
    //MARK:- ACTION BUTTONS
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- PAGEVIEW CONTROLLER
extension OrderPagerViewVC: PageViewControllerDelegate {
    func scroll(index: Int) {
        self.selectOrderType(index: index)
        self.scrollToIndex(index: index)
    }
}

//MARK:- EXTENSION COLLECTION VIEW
extension OrderPagerViewVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNameCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentOrderCollectionViewCell", for: indexPath) as! CurrentOrderCollectionViewCell
        
        if indexPath.row == selectedIndex {
            cell.viewGreenLine.isHidden = false
        } else {
            cell.viewGreenLine.isHidden = true
        }
        cell.lblName.text = arrNameCategories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectOrderType(index: indexPath.item)
        self.scrollToIndex(index: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectnView.frame.size.width/4, height: collectnView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
