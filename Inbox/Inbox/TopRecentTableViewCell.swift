//
//  TopRecentTableViewCell.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 28/5/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Common
import Kingfisher

class TopRecentTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    var recentArray:[ThreadsData] = []
    
    weak var delegate:RowTapedDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath as IndexPath) as! RecentCollectionViewCell
        
        let singleThread = recentArray[indexPath.item]
        
        cell.userNameLabel.text = singleThread.fullName
        
        let imageurl = URL(string: "https://storage.googleapis.com/disco-outpost-198321.appspot.com/image/photos/\(singleThread.user_image_thumb!)")
        
        cell.userImageView.kf.setImage(with: imageurl)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt",indexPath.item)
        
        let singleThread = recentArray[indexPath.item]
        
        let peerId = singleThread.authId!
        
        APIManager.manager.initiateThread(id: peerId) { (threadId, msg) in
            
            
            if msg == "Thread Found"{
                
                if self.delegate != nil {
                    
                    self.delegate?.cellTapped(threadId!,singleThread.fullName!,singleThread.isPin!)
                }
               
            }
            
        }
        
    }

}
