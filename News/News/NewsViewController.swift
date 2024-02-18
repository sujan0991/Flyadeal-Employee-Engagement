//
//  NewsViewController.swift
//  News
//
//  Created by Md.Ballal Hossen on 15/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common

public class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsList:[NewsData] = []
    
    let refreshControl = UIRefreshControl()

    override public func viewDidLoad() {
        super.viewDidLoad()

        print("???????? : ",UserDefaults.standard.object(forKey: "test") ?? 0)
        
       // self.placeNavBar(withTitle: "NEWS", isBackBtnVisible: false)
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        
        
        
        
        newsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action:  #selector(getNews), for: .valueChanged)
        
        
            
        }
    
    public override func viewWillAppear(_ animated: Bool) {
    
        getNews()
    }
        
    
    
    @objc func getNews() {
        
        print("getNews()")
        
        APIManager.manager.allNews(title: "", page: 1) { (userData, msg) in
            
            
            print("userData......???????/////",msg!)
            
            if msg == "Unauthorized Access"{
                
                self.getNews()
                
            }else if msg == "Logout"
            {
                
                let tempDic = ["Logout" : "Logout"]
                // call in appdelegate
                self.navigate(MyNavigation.logOut,from:self, info: tempDic as Dictionary<String, Any>)
                
            }else{
                
                self.newsList = userData!
                self.newsTableView.reloadData()
                
            }
       
        self.refreshControl.endRefreshing()
    }
    
    }

    //table view **********
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsList.count
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "newsCell")! as! NewsTableViewCell
        
        let singleNews = newsList[indexPath.row]
        cell.setInfo(singleNews)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleNews = newsList[indexPath.row]
        
        let tempDic = ["newsId" : singleNews.id]
        // call in appdelegate
        navigate(MyNavigation.newsDetail,from:self, info: tempDic as Dictionary<String, Any>)
        
        
        
    }

//*********
    
   

}
