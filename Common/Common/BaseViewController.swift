//
//  BaseViewController.swift
//  Common
//
//  Created by Md.Ballal Hossen on 25/4/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    
    var navigationBar = CustomNavigationBar()
    

    override open func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    // public methods
    open func placeNavBar(withTitle title: String, isBackBtnVisible visible: Bool) {
        
        navigationBar = CustomNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 74.0 + extraTop()))
        
        if visible{
            
            navigationBar.showBackButton()
        }else{
            navigationBar.hideBackButton()
        }
        
        navigationBar.headerLabel.text = title
        
        self.view.addSubview(navigationBar)
    }


// private methods
   private func extraTop() -> CGFloat {
     var top: CGFloat = 0
     if #available(iOS 11.0, *) {
        if let t = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            if t > 0 {
                top = t - 20.0
            } else {
                top = t
            }
        }
    }
    return top
}


}
