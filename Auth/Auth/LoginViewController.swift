//
//  LoginViewController.swift
//  Auth
//
//  Created by Md.Ballal Hossen on 11/4/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import SwiftKeychainWrapper

public class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    var userMetaData:UserMetaData?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveFCMToken(_:)), name:NSNotification.Name(rawValue: "FCMToken"), object: nil)
    }


    @IBAction func loginButtonAction(_ sender: Any) {
        
        
        APIManager.manager.login(email: emailTextField.text!, password: passWordTextField.text!) { (userData, msg) in
            
            self.userMetaData = userData

            print(".........",self.userMetaData!.userUsername ?? "")
            
            //save refresh token to keychain
            KeychainWrapper.standard.set(self.userMetaData!.refreshToken ?? "", forKey: "refreshToken")
            KeychainWrapper.standard.set(self.userMetaData!.accessToken ?? "", forKey: "accessToken")
            
            //must remove it from keychain after logout**************
            
            
            //user info in userDefault
            
            var tempDic: [String:String] = [:]
            tempDic["first_name"] = self.userMetaData?.userFirstName
            tempDic["last_name"] = self.userMetaData?.userLastName
            //tempDic["user_id"] = self.userMetaData?.userId
            tempDic["company_name"] = self.userMetaData?.companyName
            tempDic["user_image_thumbnail"] = self.userMetaData?.userImageThumbnail ?? "no image"
            
            UserDefaults.standard.setValue(tempDic, forKey: "userInfo")

            
            print(".........????????????",self.userMetaData?.userId)
            
            
            //After successful login post notification to set new rootview in appdelegate
            NotificationCenter.default.post(name: Notification.Name("logindone"), object: nil, userInfo: nil)
        }
        
       
    }
    
    @objc func onDidReceiveFCMToken(_ notification:Notification) {
       
        //temp
        if  let fcmToken: String = KeychainWrapper.standard.string(forKey: "fcmToken"){
            
            print("fcmToken in login screen : \(fcmToken)")
            
        }

    }
    
    
    @IBAction func forgetDetailsButtonAction(_ sender: Any) {
        
       
        navigate(MyNavigation.forgetPassword,from:self,info: Dictionary())
        
        
    }
    
    

}
