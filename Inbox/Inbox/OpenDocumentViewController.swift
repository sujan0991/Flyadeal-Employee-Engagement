//
//  OpenDocumentViewController.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 16/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import WebKit

class OpenDocumentViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navTitle: UILabel!
    
    var webUrl:URL!
    var fileName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitle.text = fileName
        webView.load(NSURLRequest(url: webUrl!) as URLRequest)

    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        dismiss(animated: true) {
            
            
        }
    }
    

}
