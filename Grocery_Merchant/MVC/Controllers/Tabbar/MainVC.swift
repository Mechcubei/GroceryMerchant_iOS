//
//  MainVC.swift
//  Grocery_Merchant
//
//  Created by osx on 21/10/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class MainVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var bannerCollectionView: UICollectionView!
    @IBOutlet var selectOptionCollectionView: UICollectionView!
    @IBOutlet var pagingView: UIPageControl!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var imgProfile: UIImageView!
    
    //MARK:- LOCAL VARIABLES
    var timer = Timer()
    var counter = 0
    var currentIndex = 0
    var arrBannerList = [BannerListStruct2]()
    var arrImg = [UIImage(named: "category"),UIImage(named: "current-order"),UIImage(named: "history"),UIImage(named: "payment"),UIImage(named: "tracking-order"),UIImage(named: "setting")]
    var arrLabel = ["Categories","Current Orders","Order History","Payment","Track Order","Setting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.bannerList()
        self.setPaging()
        self.setCollectionViewHeight()
        self.imgProfile.cornerRadius = imgProfile.frame.size.width/2
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.bannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        self.selectOptionCollectionView.register(UINib(nibName: "SelectMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectMenuCollectionViewCell")
        
    }
    //MARK:- BANNER LIST API
    func bannerList() {
        
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.bannerList(params: params) { (data:BannerListStruct) in
            print(data)
            self.arrBannerList = data.data
            self.bannerCollectionView.reloadData()
        }
    }
    
    func setCollectionViewHeight() {
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.collectionViewHeight.constant = self.selectOptionCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    //SET PAGING ON BANNERS
    func setPaging() {
        
        self.pagingView.numberOfPages = arrBannerList.count
        self.pagingView.currentPage = currentIndex
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        
    }
    // AUTOSLIDER CHANGE IMAGE
    @objc func changeImage() {
        
        let index = IndexPath.init(item: counter, section: 0)
        self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        counter += 1
    }
}

//MARK:- EXTENTION COLLECTION VIEW
@available(iOS 13.0, *)
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.bannerCollectionView) {
            return arrBannerList.count
        } else {
            return arrImg.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            let imgUrl = arrBannerList[indexPath.row].banner_image
            cell.imgView.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: ""))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectMenuCollectionViewCell", for: indexPath) as! SelectMenuCollectionViewCell
            cell.imgView.image = arrImg[indexPath.row]
            cell.imgView.image = cell.imgView.image?.withRenderingMode(.alwaysTemplate)
            cell.imgView.tintColor = UIColor(red: 97/255, green: 161/255, blue: 20/255, alpha: 1)
            cell.lblName.text = arrLabel[indexPath.row]
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bannerCollectionView {
            return CGSize(width: bannerCollectionView.frame.size.width, height: bannerCollectionView.frame.size.height)
        } else {
            return CGSize(width: selectOptionCollectionView.frame.size.width/2, height: selectOptionCollectionView.frame.size.width/2)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.bannerCollectionView {
            return 0
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.bannerCollectionView {
            return 0
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay c: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        currentIndex = indexPath.item
        self.pagingView.currentPage = currentIndex
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let vc = ENUM_STORYBOARD<DashboardVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            
            let vc = ENUM_STORYBOARD<OrderPagerViewVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 2 {
            
            let vc = ENUM_STORYBOARD<OrderHistoryVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3 {
            
        }else if indexPath.row == 4 {
            
        }else if indexPath.row == 5 {
            
            let vc = ENUM_STORYBOARD<SettingVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
