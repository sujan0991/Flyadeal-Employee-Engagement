//
//  StaffListViewController.swift
//  StaffDirectory
//
//  Created by Md.Ballal Hossen on 19/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import Kingfisher
import SVProgressHUD
import Inbox

public class StaffListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var stafTableView: UITableView!
    
    var staffList = [Dictionary<String,Any>]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        stafTableView.delegate = self
        stafTableView.dataSource = self
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        APIManager.manager.getStaffList(c_Name: "s", page_no: 1) { (userData, msg) in
            
            
          self.staffList = userData["user_list"] as! [Dictionary<String, Any>]
            
            
           
            print("............",self.staffList.count)
            
            self.stafTableView.reloadData()
            
       }
    }
    

    //table view **********
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return staffList.count
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : StaffTableViewCell = tableView.dequeueReusableCell(withIdentifier: "staffCell")! as! StaffTableViewCell
        
        let singleStaff = staffList[indexPath.row]
        
       
        cell.nameLabel.text = "\(String(describing: singleStaff["first_name"]!)) \(String(describing: singleStaff["last_name"]!))"
        
        let imageurl = URL(string: "https://storage.googleapis.com/disco-outpost-198321.appspot.com/image/photos/\(String(describing: singleStaff["user_image_thumb"]!))")
        
        cell.profileImageView.kf.setImage(with: imageurl)
        
        cell.sendMessageButton.tag = indexPath.row
        
        cell.sendMessageButton.addTarget(self, action: #selector(sendMessageAction(_:)), for: .touchUpInside)
        
        let  currentuserId = UserDefaults.standard.value(forKey: "userId") as! String

        print("userInfoDi user_id",currentuserId,(singleStaff["id"] as! String))
        if  currentuserId == (singleStaff["id"] as! String) {
            
            cell.sendMessageButton.isHidden = true
        }
       
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleStaff = staffList[indexPath.row]
        
        
        let storyBoard = UIStoryboard(name: "StaffDirectory", bundle: Bundle(for: StaffListViewController.self ))
        
        let vc :ProfileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
         vc.userId = singleStaff["id"] as! String
        
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
    //*********
    
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        
       
        let singleStaff = staffList[sender.tag]
        let userId = singleStaff["id"] as! String
        
         print("sendMessageAction.........",userId)
        
        SVProgressHUD.show()
        APIManager.manager.initiateThread(id: userId) { (threadId, msg) in
            
            
            if msg == "Thread Found"{
                
                SVProgressHUD.dismiss()
                
                let storyBoard = UIStoryboard(name: "Inbox", bundle: Bundle(for: InboxViewController.self ))
                
                let vc :ChatViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                
                vc.threadId = threadId!
                vc.userName = singleStaff["first_name"] as! String
//                vc.isPined = singleThread.isPin!
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
