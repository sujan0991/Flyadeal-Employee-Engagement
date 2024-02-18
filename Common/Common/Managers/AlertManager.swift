//
//  AlertManager.swift
//  TT
//
//  Created by Dulal Hossain on 4/24/17.
//  Copyright © 2017 DL. All rights reserved.
//

import Foundation
import UIKit

protocol AlertManagerDelegate {
    
    func didPressConfirmation()
}
class AlertManager {
    
    var delegate: AlertManagerDelegate?
    
    func showAlert(vc: UIViewController, msg:String, title:String){
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cancelar", style: .default, handler: { (aciton) in
            vc.dismiss(animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "Feito", style: .default, handler: { (aciton) in
            
            self.delegate?.didPressConfirmation()
        })
        
        alertVC.addAction(okAction)
        alertVC.addAction(noAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
}
