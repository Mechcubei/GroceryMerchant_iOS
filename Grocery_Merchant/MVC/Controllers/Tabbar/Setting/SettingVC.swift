
//
//  SettingVC.swift
//  Grocery_Merchant
//
//  Created by osx on 10/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)

class SettingVC: UIViewController {
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingActions(sender:UIButton){
        self.moveToScreen(index: sender.tag)
    }

    func moveToScreen(index:Int){
        var vc:UIViewController!
        switch index {
        case 0: vc = ENUM_STORYBOARD<ProfileViewController>.tabbar.instantiativeVC()
        case 1: vc = ENUM_STORYBOARD<NotificationVC>.tabbar.instantiativeVC()
        case 2: vc = ENUM_STORYBOARD<ProfileViewController>.tabbar.instantiativeVC()
        case 3: vc = ENUM_STORYBOARD<ProfileViewController>.tabbar.instantiativeVC()
        case 4: vc = ENUM_STORYBOARD<ProfileViewController>.tabbar.instantiativeVC()
        case 5: vc = ENUM_STORYBOARD<ProfileViewController>.tabbar.instantiativeVC()
        case 6: self.logoutAlert()
        default: break
        }
        
        guard index != 6 else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- FUNC LOGOUT

    func logoutAlert(){
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure, you want to logout? ", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.logOut()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    func logOut() {
        UserDefaults.standard.set(nil, forKey: "token")
        let tabBarStoryBoard = UIStoryboard.init(name: "Login", bundle: nil)
        let dashboard = tabBarStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(dashboard, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
}
