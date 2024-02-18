//
//  NewsDetailsViewController.swift
//  News
//
//  Created by Md.Ballal Hossen on 26/4/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common

public class NewsDetailsViewController: UIViewController {
    
    public var newsId = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        print("newsId",newsId)
        
        getSingleNews()
    }
    
    func getSingleNews() {
        
        APIManager.manager.singleNews(id: newsId) { (userData, msg) in
            
            
            print("message......",userData!)
            
            self.titleLabel.text = userData!.title
            self.detailLabel.text = userData!.description
            
            let dateHelper = DateTimeHelper()
            
            self.timeLabel.text = dateHelper.getDateString(atFormat: "h:mm a", fromFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: userData!.dateCreated!)
            
            self.dateLabel.text = dateHelper.getDateString(atFormat: "MMM d, yyyy", fromFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: userData!.dateCreated!)
            
            self.typeLabel.text = userData!.newsCategoryName
            
            
            
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
