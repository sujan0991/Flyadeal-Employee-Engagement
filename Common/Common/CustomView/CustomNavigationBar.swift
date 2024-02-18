//
//  CustomNavigationBar.swift
//  Welltravel
//
//  Created by Amit Sen on 13/12/17.
//  Copyright © 2017 Amit Sen. All rights reserved.
//

import UIKit


class CustomNavigationBar: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    // private methods

    private func customInit() {
        
        Bundle.main.loadNibNamed("CustomNavigationBar", owner: self, options: nil)
//        containerView.backgroundColor = viewModel.colors.navBarBg
//        headerLabel.textColor = viewModel.colors.navBarText
        self.addSubview(containerView)
        containerView.frame = self.bounds
    }

    // public methods
//    public func activateBtn(navBarTitle: String,
//                            isMenuBtnVisible visible: Bool,
//                            onBtnPressed callback: @escaping(UIButton) -> Void) {
//
//        headerLabel.text = navBarTitle
//        if visible {
//            menuBtn.isHidden = false
//            backBtn.isHidden = true
//            _ = menuBtn.reactive.tap.observeNext {
//                callback(self.menuBtn)
//            }
//        } else {
//            menuBtn.isHidden = true
//            backBtn.isHidden = false
//            _ = backBtn.reactive.tap.observeNext {
//                callback(self.backBtn)
           // }
     //   }
 //   }
    
    public func hideBackButton(){
        
        backBtn.isHidden = true
    }
    
    public func showBackButton(){
        
        backBtn.isHidden = false
    }
}
