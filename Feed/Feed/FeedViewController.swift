//
//  FeedViewController.swift
//  Feed
//
//  Created by Md.Ballal Hossen on 12/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import Kingfisher


public class FeedViewController: UIViewController,DrawerControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var writeStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var writeStatusView: UIView!
    var lastContentOffset: CGFloat = 0

    
    var drawerVw = DrawerView()

    var menuArray = [Dictionary<String,Any>]()

    override public func viewDidLoad() {
        super.viewDidLoad()
        //set views and action of those views
        print("????????.... : ",self.navigationController?.navigationBar.frame.size.height ?? 0)
        
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        decorateView()
        
        
        UserDefaults.standard.set(99, forKey: "test")
        
    }
    
    
   func decorateView(){
    
    //make circle
    profilePicImageView.makeCircle()
    
    //add tap Gesture
    profilePicImageView.isUserInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    profilePicImageView.addGestureRecognizer(tapGestureRecognizer)
    
    
    
    }
  
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        drawerVw = DrawerView(aryControllers:DrawerArray.array, isBlurEffect:false, isHeaderInTop:true, controller:self)
        drawerVw.delegate = self
       
        
        drawerVw.btnLogOut.setTitle("Name", for: .normal)
        drawerVw.changeGradientColor(colorTop: UIColor("#411D59"), colorBottom: UIColor("#411D59"))
        drawerVw.changeCellTextColor(txtColor: UIColor.white)
        drawerVw.changeUserNameTextColor(txtColor: UIColor.white)
       // drawerVw.changeFont(font: UIFont(name:"Avenir Next", size:18)!)
        drawerVw.changeUserName(name: "Josep Vijay")
        drawerVw.show()
    }
    
    
    //drawer delegate
    func pushTo(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FeedImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "feedImageCell")! as! FeedImageTableViewCell
        
        if indexPath.section%2 == 0{
            
            cell.feedImageView.isHidden = true
            cell.feedImageHeight.constant = 0
        }
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.lastContentOffset = scrollView.contentOffset.y
        
         print("scrollViewWillBeginDragging")
    }
    
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            print("did move up")
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.writeStatusViewHeight.constant = 0
                self.view.layoutIfNeeded()
            })
            
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            //
             print("did move down")
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.writeStatusViewHeight.constant = 50
                self.view.layoutIfNeeded()
            })
        } else {
            // didn't move
        }
    }
    public func test() {
        
        print("it works");
    }
    


    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}

struct DrawerArray {
    static let array:NSArray = ["MY CONTACTS", "STAFF DIRECTORY", "DOCUMENTS","FORMS", "SURVEYS", "LEARNING HUB", "SETTINGS"]
    
}
