//
//  MessageTableViewCell.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 28/5/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import Kingfisher

class MessageTableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var pinImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.makeRound(10, borderWidth: 0, borderColor: UIColor.clear)
    }
    
    func setInfo(_ thread:ThreadsData) {
        
        if !thread.isSeen! {
            
            self.nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.messageLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            dotImage.isHidden = false
            
        }else{
            
            self.nameLabel.font = UIFont.systemFont(ofSize: 16.0)
            self.messageLabel.font = UIFont.systemFont(ofSize: 15.0)
            dotImage.isHidden = true
        }
        
        if thread.isPin!{
            
            pinImage.isHidden = false
            
        }else{
            
             pinImage.isHidden = true
        }
        self.nameLabel.text = thread.fullName
        
        self.messageLabel.text = thread.lastMessage
        
        let dateHelper = DateTimeHelper()
        
        self.dateLabel.text = dateHelper.getDateString(atFormat: "h:mm a", fromFormat: "yyyy-MM-dd'T'HH:mm:ssXXXXX", dateString: thread.lastUpdated!)
        
        let imageurl = URL(string: "https://storage.googleapis.com/disco-outpost-198321.appspot.com/image/photos/\(thread.user_image_thumb!)")
        
        self.userImageView.kf.setImage(with: imageurl)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
