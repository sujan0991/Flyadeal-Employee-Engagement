//
//  RecentCollectionViewCell.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 27/5/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common

protocol RowTapedDelegate:class {
    
    func cellTapped(_ threadId:String,_ userName:String,_ isPinned:Bool)
}

class RecentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        //make circle
        userImageView.makeCircle()
        
    }
}
