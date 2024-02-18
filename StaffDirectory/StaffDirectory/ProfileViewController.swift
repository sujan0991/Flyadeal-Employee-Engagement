//
//  ProfileViewController.swift
//  StaffDirectory
//
//  Created by Md.Ballal Hossen on 21/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import Kingfisher
import SVProgressHUD
import Inbox

public class ProfileViewController: UIViewController {
    
    public var userId: String!
    var userInfoDic:Dictionary<String,Any>!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sendmessagebutton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        APIManager.manager.getUserInfo(id: userId) { (userData, msg) in
            
            print(".............",userData["user_info"])
            
            let userInfo = userData["user_info"] as! Dictionary<String,Any>
            
            self.userInfoDic = userInfo
            
            
            self.nameLabel.text = "\(String(describing: userInfo["first_name"]!)) \(String(describing: userInfo["last_name"]!))"
            
            let imageurl = URL(string: "https://storage.googleapis.com/disco-outpost-198321.appspot.com/image/photos/\(String(describing: userInfo["user_image_large"]!))")
            
            
            self.profileImageView.kf.setImage(with: imageurl)
            
            SVProgressHUD.dismiss()
        }
        
        
        if userId == (UserDefaults.standard.value(forKey: "userId") as! String) {
            
            sendmessagebutton.isHidden = true
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func sendMessageButtonAction(_ sender: Any) {
        
        SVProgressHUD.show()
        APIManager.manager.initiateThread(id: userId) { (threadId, msg) in


            if msg == "Thread Found"{

                SVProgressHUD.dismiss()

                let storyBoard = UIStoryboard(name: "Inbox", bundle: Bundle(for: InboxViewController.self ))

                let vc :ChatViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController

                vc.threadId = threadId!
                vc.userName = self.userInfoDic["first_name"] as! String
                //  vc.isPined = singleThread.isPin!

                self.navigationController?.pushViewController(vc, animated: true)

            }

        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
