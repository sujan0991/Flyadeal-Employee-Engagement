//
//  EventListViewController.swift
//  Events
//
//  Created by Md.Ballal Hossen on 14/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common

public class EventListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var eventTableView: UITableView!
    
    var eventType : EventType = .upcoming

     let refreshControl = UIRefreshControl()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.refreshControl = refreshControl
      //  refreshControl.addTarget(self, action:  #selector(getNews), for: .valueChanged)
        
    }
    

    //table view **********
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if eventType == .upcoming{
            return 10
        }else if eventType == .myEvent{
            return 5
        }else{
            return 7
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eventsCell")! as! EventListTableViewCell
        
      
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let singleNews = newsList[indexPath.row]
//
        let tempDic = ["eventId" : ""]
        // call in appdelegate
        navigate(MyNavigation.eventsDetail,from:self,info: tempDic as Dictionary<String, Any>)
        
        
        
    }


}
