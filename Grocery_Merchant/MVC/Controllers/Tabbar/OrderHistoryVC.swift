//
//  OrderHistoryVC.swift
//  Grocery_Merchant
//
//  Created by osx on 22/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class OrderHistoryVC: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var viewAllOrder: UIView!
    @IBOutlet var viewCompleted: UIView!
    @IBOutlet var viewCancel: UIView!
    
    
    //MARK:- SET UP PAGEVIEW CONTROLLER
    lazy var aboutSelfPVC: PageViewController = {
        let viewController = PageViewController(transitionStyle:
            UIPageViewController.TransitionStyle.scroll, navigationOrientation:
            UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        viewController.pages = {
            return [
                getViewController(withIdentifier: "AlertVC"),
                getViewController(withIdentifier: "AlertVC"),
                getViewController(withIdentifier: "AlertVC")
            ]
        }()
        
        func getViewController(withIdentifier identifier: String) -> UIViewController{
            return UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(asChildViewController: self.aboutSelfPVC)
        self.aboutSelfPVC.delegateScroll = self
        
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
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- PAGEVIEW CONTROLLER
extension OrderHistoryVC: PageViewControllerDelegate {
    func scroll(index: Int) {
        if index == 0 {
            viewAllOrder.backgroundColor = ENUMCOLOUR.themeColour.getColour()
            viewCompleted.backgroundColor = UIColor.clear
            viewCancel.backgroundColor = UIColor.clear
        } else if index == 1 {
            viewAllOrder.backgroundColor = UIColor.clear
            viewCompleted.backgroundColor = ENUMCOLOUR.themeColour.getColour()
            viewCancel.backgroundColor = UIColor.clear
        } else {
            viewAllOrder.backgroundColor = UIColor.clear
            viewCancel.backgroundColor = ENUMCOLOUR.themeColour.getColour()
            viewCompleted.backgroundColor = UIColor.clear
        }
    }
}
