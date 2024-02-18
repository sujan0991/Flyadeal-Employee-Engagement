//
//  MessageData.swift
//  Inbox
//
//  Created by Md.Ballal Hossen on 26/6/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

final internal class MessageData {
    
    static let shared = MessageData()
    
    private init() {}
    
    enum MessageTypes: String, CaseIterable {
        case Text
        case AttributedText
        case Photo
        case Video
        case Audio
        case Emoji
        case Location
        case Url
        case Phone
        case Custom
        case ShareContact
    }
    
    

}
