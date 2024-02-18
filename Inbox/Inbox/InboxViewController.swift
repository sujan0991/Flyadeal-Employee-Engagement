//
//  InboxViewController.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 27/5/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import SVProgressHUD

public class InboxViewController: UIViewController,RowTapedDelegate {
    
    //collectionview roe tap delegate
    
    func cellTapped(_ threadId: String, _ userName: String, _ isPinned:Bool) {
        
        let storyBoard = UIStoryboard(name: "Inbox", bundle: Bundle(for: InboxViewController.self ))
        
        let vc :ChatViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        vc.threadId = threadId
        vc.userName = userName
        vc.isPined = isPinned
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
  
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var messageThreadArray:[ThreadsData] = []
    
    let refreshControl = UIRefreshControl()
    
    //temporary for testing
    var searchList = [[String:Any]]()

    var filtered = [[String:Any]]()
    
    var apiCallTimer = Timer()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.tableFooterView = UIView()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.lightGray
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        
       
        
//        messageTableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action:  #selector(getAllThreads), for: .valueChanged)
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = false
        
        
        SVProgressHUD.show()
        getAllThreads()
        
        // start the timer
        apiCallTimer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        
        apiCallTimer.invalidate()
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        
        print("timer called")
        
        getAllThreads()
    }
    
    @objc func getAllThreads() {
        
        
        
        APIManager.manager.allThreads { (userData, msg) in
            
            if msg == "Unauthorized Access"{
                
                self.getAllThreads()
                
            }else if msg == "Logout"
            {
                SVProgressHUD.dismiss()
                
                let tempDic = ["Logout" : "Logout"]
                // call in appdelegate
                self.navigate(MyNavigation.logOut,from:self,info: tempDic as Dictionary<String, Any>)
                
            }else{
                
                SVProgressHUD.dismiss()
                
                print("user data ",userData!)
                
                self.messageThreadArray = userData!.threads!
                
                
                
                self.messageTableView.reloadData()
                
                for singleMessage in self.messageThreadArray{
                    
                    let tempDic = ["name":singleMessage.fullName ?? "No Name","threadId":singleMessage.thread_id ?? "No Thread","is_pinned":singleMessage.isPin ?? false,"authId":singleMessage.authId ?? "No Id"] as [String : Any]
                    
                    self.searchList.append(tempDic)
                    
                }
                
            }
        }

    }
    

    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    
}





//extension for tableview************
extension InboxViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    //table view **********
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == messageTableView {
            
           return 2
            
        }else{
            
            return 1
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if tableView == messageTableView {
            
            if section == 0 {

                return 1

            }else if section == 1{

                return self.messageThreadArray.count
            }
        }else{
            
           return filtered.count
        }
        
      return 0
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == messageTableView {
            
            if indexPath.section == 0 {

                let cell : TopRecentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "topRecentCell")! as! TopRecentTableViewCell

                cell.recentArray = messageThreadArray
                cell.delegate = self
                cell.recentCollectionView.reloadData()
                
                return cell

            }else if (indexPath.section == 1){
            
                
                let cell : MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "inboxCell")! as! MessageTableViewCell
                
                let singleThread = messageThreadArray[indexPath.row]
                
                
                cell.setInfo(singleThread)
                
                
                return cell
            }

        }else{
            
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
            
            let singleThread = filtered[indexPath.row]
            cell.textLabel?.text = singleThread["name"] as? String
            
            return cell
            
        }
        
        
        return UITableViewCell()
        
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt",indexPath.row)
        
        if tableView == messageTableView {
            
        let singleThread = messageThreadArray[indexPath.row]
        
        let peerId = singleThread.authId!
        
        SVProgressHUD.show()
        APIManager.manager.initiateThread(id: peerId) { (threadId, msg) in
            
           
            if msg == "Thread Found"{

                SVProgressHUD.dismiss()
                
                let storyBoard = UIStoryboard(name: "Inbox", bundle: Bundle(for: InboxViewController.self ))
                
                let vc :ChatViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                
                vc.threadId = threadId!
                vc.userName = singleThread.fullName!
                vc.isPined = singleThread.isPin!
               
                self.navigationController?.pushViewController(vc, animated: true)
             
            }

        }
        

        
//    self.navigationController?.pushViewController(AdvancedExampleViewController(), animated: true)

        }else{
            
            let singleThread = filtered[indexPath.row]
            
            let peerId:String = singleThread["authId"] as! String
            
            APIManager.manager.initiateThread(id: peerId) { (threadId, msg) in
                
                
                if msg == "Thread Found"{
                    
                    
                    let storyBoard = UIStoryboard(name: "Inbox", bundle: Bundle(for: InboxViewController.self ))
                    
                    let vc :ChatViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    vc.threadId = threadId!
                    vc.userName = singleThread["name"] as! String
                    vc.isPined = singleThread["is_pinned"] as! Bool
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
        }
    }
    
   
    
}


//uextension for uisearchbar


extension InboxViewController: UISearchBarDelegate{
    
    
   public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        searchResultTableView.isHidden = true
    }
    
   public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
    
   public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", searchText)
    
        filtered.removeAll()
        filtered = searchList.filter{ searchPredicate.evaluate(with: $0) };
    
   
        print("filtered array",filtered)

        if(filtered.count == 0){
            
            searchResultTableView.isHidden = true
        } else {
            searchResultTableView.isHidden = false
            
        }
        self.searchResultTableView.reloadData()
    }
    

}
