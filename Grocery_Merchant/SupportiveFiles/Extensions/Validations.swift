
//  Validations.swift
//  Learning
//  Created by Amandeep tirhima on 2020-04-22.
//  Copyright © 2020 Amandeep tirhima. All rights reserved.

import Foundation
import UIKit

enum Valid {
    case success
    case failure(String)
}

class Validations{
    
    static let shareInstance = Validations()
        
    // Email validation
    func validateEmail(email: String) -> Bool {
        
           if !email.isBlank {
               
               let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
               let status = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
               
               if status {
                   return true
               } else {
                 
                   return false
               }
           }
           return true
       }
        
    // SignUp valiation
    func validateSignUp(groceryName:String,firstName:String,lastName:String,gstNumber:String,address:String,image:Bool) -> Valid{
        
        if groceryName.isEmpty {
            
            return Valid.failure( AlertMessages.emptyGroceryName.rawValue)
            
        } else if firstName.isEmpty {
            
            return Valid.failure( AlertMessages.emptyFirstName.rawValue)
            
        } else if lastName.isEmpty  {
            
            return Valid.failure(AlertMessages.emptyLastName.rawValue)
            
        } else if gstNumber.isEmpty {
            
            return Valid.failure( AlertMessages.emptyGSTINNumber.rawValue)
            
        } else if address.isEmpty {
            
            return Valid.failure( AlertMessages.emptyAddress.rawValue)
            
        } else if image == false {
            
            return Valid.failure(AlertMessages.emptyImage.rawValue)
        }
        

        return Valid.success
    }
    
    func validLogin(email:String) -> Valid {
        if email.isEmpty{
            return Valid.failure(AlertMessages.emptyEmailId.rawValue)
            
        } else if  !(email.isEmpty) {
            
            if !self.validateEmail(email: email){
                
                return Valid.failure(AlertMessages.notValidEmailId.rawValue)
                
            }
        }
        return Valid.success
    }
}
