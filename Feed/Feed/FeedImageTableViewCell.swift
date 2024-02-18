//
//  FeedImageTableViewCell.swift
//  Feed
//
//  Created by Md.Ballal Hossen on 18/8/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

class FeedImageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var feedProPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var depertmentLabel: UILabel!
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedImageHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
