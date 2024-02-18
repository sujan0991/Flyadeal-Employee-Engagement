//
//  StaffTableViewCell.swift
//  StaffDirectory
//
//  Created by Md.Ballal Hossen on 19/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var addToContactButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
