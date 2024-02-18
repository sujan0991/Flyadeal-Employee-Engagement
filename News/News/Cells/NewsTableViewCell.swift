//
//  NewsTableViewCell.swift
//  News
//
//  Created by Md.Ballal Hossen on 26/4/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setInfo(_ news:NewsData)  {
        
        self.titleLabel.text = news.title
        self.detailLabel.text = news.description
        self.typeLabel.text = news.newsCategoryName
        
    
        let dateHelper = DateTimeHelper()
        
        let createdDate = news.dateCreated
        self.dateLabel.text = dateHelper.getDateString(atFormat: "d", fromFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: createdDate!)
        self.dayLabel.text = dateHelper.getDateString(atFormat: "EEEE", fromFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: news.dateCreated!)
        self.timeLabel.text = dateHelper.getDateString(atFormat: "h:mm a", fromFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: news.dateCreated!)
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
