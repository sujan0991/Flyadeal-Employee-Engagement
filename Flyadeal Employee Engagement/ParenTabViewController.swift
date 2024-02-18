//
//  ParenTabViewController.swift
//  Flyadeal Employee Engagement
//
//  Created by Md.Ballal Hossen on 12/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Feed
import News
import Common
import Inbox
import Events
import StaffDirectory

class ParenTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add view from diffenrent module to TabBarController
        
        // FeedviewController
        let s = UIStoryboard (
            
            name: "Feed", bundle: Bundle(for: FeedViewController.self)
            
        )

        let vc = s.instantiateViewController(withIdentifier: "FeedViewController")
        
        let icon1 = UITabBarItem(title: "Feed", image: UIImage(named: "Feed.png"), selectedImage: UIImage(named: "Feed-Selected.png"))
        
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        nav.tabBarItem = icon1
        
        //NewsViewcontroller
        let s2 = UIStoryboard (
            name: "News", bundle: Bundle(for: NewsViewController.self )
        )
        let vc2 = s2.instantiateViewController(withIdentifier: "NewsViewController")
        
        let icon2 = UITabBarItem(title: "News", image: UIImage(named: "News.png"), selectedImage: UIImage(named: "News-Selected.png"))
        
        
        let nav1 = UINavigationController(rootViewController: vc2)
        nav1.navigationBar.isHidden = true
        nav1.tabBarItem = icon2
        
        //InboxViewcontroller
        let s3 = UIStoryboard (
            name: "Inbox", bundle: Bundle(for: InboxViewController.self )
        )
        let vc3 = s3.instantiateViewController(withIdentifier: "InboxViewController")
        
        let icon3 = UITabBarItem(title: "Inbox", image: UIImage(named: "inbox.png"), selectedImage: UIImage(named: "inbox_selected.png"))
        
        
        let nav2 = UINavigationController(rootViewController: vc3)
        nav2.navigationBar.isHidden = true
        nav2.tabBarItem = icon3
        
        
        //EventsViewController
        let s4 = UIStoryboard (
            name: "Events", bundle: Bundle(for: EventsViewController.self )
        )
        let vc4 = s4.instantiateViewController(withIdentifier: "EventsViewController")
        
        let icon4 = UITabBarItem(title: "Events", image: UIImage(named: "News.png"), selectedImage: UIImage(named: "News-Selected.png"))
        
        
        let nav4 = UINavigationController(rootViewController: vc4)
        nav4.navigationBar.isHidden = true
        nav4.tabBarItem = icon4
        
        //EventsViewController
        let s5 = UIStoryboard (
            name: "StaffDirectory", bundle: Bundle(for: StaffListViewController.self )
        )
        let vc5 = s5.instantiateViewController(withIdentifier: "StaffListViewController")
        
        let icon5 = UITabBarItem(title: "Staff", image: UIImage(named: "Staff_temp.png"), selectedImage: UIImage(named: "Staff_temp.png"))
        
        
        let nav5 = UINavigationController(rootViewController: vc5)
        nav5.navigationBar.isHidden = true
        nav5.tabBarItem = icon5

        
        
        let tabBarList = [nav,nav1,nav2,nav4,nav5]
        
        viewControllers = tabBarList
        
        self.tabBar.tintColor = UIColor("#384D78")
    }
    
}
