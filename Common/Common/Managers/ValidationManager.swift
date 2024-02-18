//
//  ValidationManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
//import SVProgressHUD


struct ValidationStr {
    
    static let  USERNAME_EMPTY_ERROR = "Please enter user name."
    static let  FULLNAME_EMPTY_ERROR = "Please enter full name."
    static let  PHONE_EMPTY_ERROR = "Please enter phone number."
    static let  COUNTRY_EMPTY_ERROR = "Please enter country."
    static let  EMAIL_EMPTY_ERROR = "Please enter email address."
    static let  INVALID_EMAIL = "Please enter valid email address."
    static let OTP_EMPTY_ERROR = "Please enter otp."
    static let  PASSWORD_EMPTY_ERROR = "Please enter password."
    static let  CONF_PASSWORD_EMPTY_ERROR = "Please enter confirm password."
    static let PASSWORD_MISMATCH_ERROR = "Password and confirm password does not match."
    
   // static let  PASSWORD_LENGTH_ERROR = "Please enter password."
    //static let  CONF_PASSWORD_LENGTH_ERROR = "Please enter password."

    static let  NAME_EMPTY_ERROR = "Please enter a name."
    
    static let  ADDRESS_EMPTY_ERROR = "Please enter a address."
    static let  IMAGE_EMPTY_ERROR = "Please select an image."
  
}

class ValidationManager: NSObject {
    
    
    /*
     *-------------------------------------------------------
     * MARK:- singletone initialization
     *-------------------------------------------------------
     */
    
    private struct Static {
        static var intance: ValidationManager? = nil
    }
    
    private static var __once: () = {
        Static.intance = ValidationManager()
    }()
    
    class var manager: ValidationManager {
        
        _ = ValidationManager.__once
        return Static.intance!
    }
    
    func validateLoginForm(userName:String, password:String) -> String {
        var msg: String = ""
        
        if userName.isEmpty {
            msg = ValidationStr.USERNAME_EMPTY_ERROR
            return msg
        }
       
        else if password.isEmpty{
            msg = ValidationStr.PASSWORD_EMPTY_ERROR
            return msg
        }
       
        return msg
    }
    
    
    func validateRegisterForm(userName:String, fullName:String,email:String,password:String,phone:String) -> String {
        
        
        var msg: String = ""
        
        if userName.isEmpty {
            msg = ValidationStr.USERNAME_EMPTY_ERROR
            return msg
        }
        if fullName.isEmpty {
            msg = ValidationStr.FULLNAME_EMPTY_ERROR
            return msg
        }
        else if email.isEmpty{
            msg = ValidationStr.EMAIL_EMPTY_ERROR
            return msg
        }
        else if password.isEmpty{
            msg = ValidationStr.PASSWORD_EMPTY_ERROR
            return msg
        }
       
        else if phone.isEmpty{
            msg = ValidationStr.PHONE_EMPTY_ERROR
            return msg
        }
        if !email.isEmpty{
            if !isValidEmail(email){
                msg = ValidationStr.INVALID_EMAIL
                return msg
            }
        }
        return msg
    }
    
    func validateEditProfileForm(fullName:String,aboutme:String) -> String {
        
        var msg: String = ""
        
        if fullName.isEmpty {
            msg = ValidationStr.FULLNAME_EMPTY_ERROR
            return msg
        }
        
        else if aboutme.isEmpty{
            msg = ValidationStr.PHONE_EMPTY_ERROR
            return msg
        }
        return msg
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validateForgotPasswordForm(email:String) -> String {
        var msg: String = ""
        
        if email.isEmpty {
            msg = ValidationStr.EMAIL_EMPTY_ERROR
            return msg
        }
        if !email.isEmpty{
            if !isValidEmail(email){
                msg = ValidationStr.INVALID_EMAIL
                return msg
            }
        }
        return msg
    }
    
    func validateResetPasswordForm(otp:String,password:String,confirmPassword:String) -> String {
        var msg = ""
        if otp.isEmpty{
            msg = ValidationStr.OTP_EMPTY_ERROR
            return msg
        }
        if password.isEmpty{
            msg = ValidationStr.PASSWORD_EMPTY_ERROR
            return msg
        }
        if password.characters.count < 3 || password.characters.count > 50{
            msg = "Password must be \(3) to \(50) characters."
            return msg
        }
        if confirmPassword.isEmpty{
            msg = ValidationStr.CONF_PASSWORD_EMPTY_ERROR

            return msg
        }
        if confirmPassword.characters.count < 3 || confirmPassword.characters.count > 50{
            msg = "Confirm password must be \(3) to \(50) characters."

            return msg
        }
        if password != confirmPassword{
            msg = ValidationStr.PASSWORD_MISMATCH_ERROR
         return msg
        }
        return msg
    }
}

extension ValidationManager{

//    func validateCreateTripForm(title:String?,selFriend:[UserModel],location:SearchPlaceModel?,locationDeatils:SearchPlaceDetailModel?,fromDate:String?,toDate:String?) -> String {
//        var msg = ""
//        if title == nil{
//            msg = "Please add a trip title."
//        }
//
//        else if location == nil {
//            msg = "Please select a location"
//        }
//        else if locationDeatils == nil {
//            msg = "Please select a location."
//        }
//        else if fromDate == nil{
//            msg = "Please select from date."
//        }
//        else if toDate == nil{
//            msg = "Please select to date."
//        }
//        else if selFriend.count == 0{
//            msg = "Please select a friend."
//        }
//        return msg
//    }
    
    
//    func validateUpdateTripForm(title:String?,selFriend:[UserModel],location:SearchPlaceModel?,locationDeatils:SearchPlaceDetailModel?,fromDate:String?,toDate:String?) -> String {
//        var msg = ""
//        if title == nil{
//            msg = "Please add a trip title."
//        }
//
//        else if location == nil {
//            msg = "Please select a location"
//        }
//        else if locationDeatils == nil {
//            msg = "Please select a location."
//        }
//        else if fromDate == nil{
//            msg = "Please select from date."
//        }
//        else if toDate == nil{
//            msg = "Please select to date."
//        }
//        else if selFriend.count == 0{
//            msg = "Please select a friend."
//        }
//        return msg
//    }
    
    func validateCreateBlogForm(title:String?,details:String?,image:UIImage?,videopath : URL?) -> String {
        var msg = ""
        if (title?.isEmpty)!{
            msg = "Please add a blog title."
            return msg
        }
        else if (details?.isEmpty)! {
            msg = "Please add a blog description"
            return msg
        }
        else if image == nil && videopath == nil {
            
            msg = "Please add a blog image or video"
            return msg
        }
       
        return msg
    }
}
