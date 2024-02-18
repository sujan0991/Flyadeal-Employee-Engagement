//
//  ForgetPasswordViewController.swift
//  Auth
//
//  Created by Md.Ballal Hossen on 1/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common

public class ForgetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func passwordRequestButtonAction(_ sender: Any) {
        
        APIManager.manager.passwordRequest(email: emailTextField.text!) { (msg) in
            
            print("passwordRequestButtonAction msg",msg)
            
            let alert = UIAlertController(title: "", message: msg!, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
