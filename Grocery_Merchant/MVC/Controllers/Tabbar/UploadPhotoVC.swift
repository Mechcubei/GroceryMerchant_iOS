//
//  UploadPhotoVC.swift
//  Grocery_Merchant
//
//  Created by osx on 12/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import Alamofire

class UploadPhotoVC: UIViewController,ImagePickerDelegate {

    //MARK:- OUTLETS
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var txtEnterAmount: UITextField!
    @IBOutlet var collectnView: UICollectionView!
    @IBOutlet var btnSelectImage: UIButton!
    
    var imagePicker: ImagePicker!
    var arrImg = [UIImage]()
    var requestID:Int?
    var UserID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.registerNibFileName()
        self.setImage()
    }
    
    // imagePi8cker  delegate  methods
      func didSelect(image: UIImage?) {
       //   self.imgView.image = image
        
        self.arrImg.append(image!)
        self.imgView.isHidden = true
        self.btnSelectImage.isUserInteractionEnabled = false
        self.collectnView.reloadData()
    

      }
    //MARK:- REGISTER NIB FILE NAME
      func registerNibFileName() {
          
          self.collectnView.register(UINib(nibName: "UploadPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UploadPhotoCollectionViewCell")
      }
    
      func setImage() {
          
          self.imgView.isHidden = arrImg.count == 0 ? false : true
    
      }
    
    
    
    //MARK:- Upload photo
    func UploadPhoto() {
        
        var parameters = [String:Any]()
        parameters = [
            "req_user_id":UserID!,
            "request_id":requestID!,
            "total_bill":"55",
            "bill_count":"44"
        ]
        
        print(parameters)
        
        let headers:[String:String] = [
            "Authorization":createHeaders()
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                        
            // For images
            for i in 0..<self.arrImg.count{
                let imgData = self.arrImg[i].jpegData(compressionQuality: 0.2)!
                let image = i + 1
                multipartFormData.append(imgData, withName: "bill_image_" + "\(image)",fileName:"file.jpg", mimeType:"image/jpg") //"image/png")
                print("image_" + "\(image)")
            }
                        
            // for other paramaters
           for (key, value) in parameters {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
           }
            
        },usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
          
          to: "http://134.209.157.211/Carrykoro/public/api/uplaod_image",
          method: .post,
          headers: headers
            )
                        
        { (result) in
            switch result {
                
            case .success(let upload, _,_ ):
                
                Loader.shared.showLoader()
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response)
                    
//                    let dashboardVC = self.navigationController!.viewControllers.filter { $0 is CategoriesVC }.first!
//                    self.navigationController!.popToViewController(dashboardVC, animated: true)
                    Loader.shared.stopLoader()
                }
               
            case .failure(let encodingError):
                
                print(encodingError)
                
                
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnUploadPhotoVC(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBAction func btnOrderReady(_ sender: Any) {
        
        self.UploadPhoto()
        
    }
}
//MARK:- EXTENSION COLLECTION VIEW
extension UploadPhotoVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadPhotoCollectionViewCell", for: indexPath) as! UploadPhotoCollectionViewCell
        
        cell.imgView.image = arrImg[indexPath.row]
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectnView.frame.size.width/2
        let height = collectnView.frame.size.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
