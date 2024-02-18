//
//  InvoiceModel.swift
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import MapKit



open class UserMetaData: Glossy {
    
    
    open var accessToken: String?
    open var companyDomain: String?
    open var companyName: String?
    open var refreshToken: String?
   
    open var userCompanyInfo: String?
    open var userCoreInfo: String?
    
    open var userFirstName: String?
    open var userImageThumbnail: String?
    open var userLastName: String?
    open var userUsername: String?
    open var userId: String?
    
    required public init?(json: Gloss.JSON) {
        accessToken = "access_token" <~~ json
        companyDomain = "company_domain" <~~ json
        companyName = "company_name" <~~ json
        refreshToken = "refresh_token" <~~ json
        userCompanyInfo = "user_company_info" <~~ json
        userCoreInfo = "user_core_info" <~~ json
        userFirstName = "user_first_name" <~~ json
        userImageThumbnail = "user_image_thumbnail" <~~ json
        userLastName = "user_last_name" <~~ json
        userUsername = "user_username" <~~ json
        userId = "user_id" <~~ json
    }
    
    open func toJSON() -> Gloss.JSON? {
        return jsonify([
            "access-token" ~~> accessToken,
            "company_domain" ~~> companyDomain,
            "company_name" ~~> companyName,
            "refresh_token" ~~> refreshToken,
            "user_company_info" ~~> userCompanyInfo,
            "user_core_info" ~~> userCoreInfo,
            "user_first_name" ~~> userFirstName,
            "user_image_thumbnail" ~~> userImageThumbnail,
            "user_last_name" ~~> userLastName,
            "user_username" ~~> userUsername,
            "user_id" ~~> userId
            ])
    }
}


public class UserModel: Glossy {
    
    var accessToken: String?
    var companyDomain: String?
    var companyName: String?
    var refreshToken: String?
    
    var userCompanyInfo: String?
    var userCoreInfo: String?
    
    var userFirstName: String?
    var userImageThumbnail: String?
    var userLastName: String?
    var userUsername: String?
    
    required public init?(json: Gloss.JSON) {
        accessToken = "access_token" <~~ json
        companyDomain = "company_domain" <~~ json
        companyName = "company_name" <~~ json
        refreshToken = "refresh_token" <~~ json
        userCompanyInfo = "user_company_info" <~~ json
        userCoreInfo = "user_core_info" <~~ json
        userFirstName = "user_first_name" <~~ json
        userImageThumbnail = "user_image_thumbnail" <~~ json
        userLastName = "user_last_name" <~~ json
        userUsername = "user_username" <~~ json
    }
    
    public func toJSON() -> Gloss.JSON? {
        return jsonify([
            "access-token" ~~> accessToken,
            "company_domain" ~~> companyDomain,
            "company_name" ~~> companyName,
            "refresh_token" ~~> refreshToken,
            "user_company_info" ~~> userCompanyInfo,
            "user_core_info" ~~> userCoreInfo,
            "user_first_name" ~~> userFirstName,
            "user_image_thumbnail" ~~> userImageThumbnail,
            "user_last_name" ~~> userLastName,
            "user_username" ~~> userUsername
            
            ])
    }
    
    


}

open class NewsData: Glossy {
    
    
    open var company: String?
    open var companyDepartment: String?
    open var dateCreated: String?
    open var dateModified: String?
    
    open var description: String?
    open var id: String?
    
    open var isActive: Bool?
    open var isDeleted: Bool?
    open var newsCategoryInfo: String?
    open var newsCategoryName: String?
    open var title: String?
    
    required public init?(json: Gloss.JSON) {
        company = "company" <~~ json
        companyDepartment = "company_department" <~~ json
        dateCreated = "date_created" <~~ json
        dateModified = "date_modified" <~~ json
        description = "description" <~~ json
        id = "id" <~~ json
        isActive = "is_active" <~~ json
        isDeleted = "is_deleted" <~~ json
        newsCategoryInfo = "news_category_info" <~~ json
        newsCategoryName = "news_category_name" <~~ json
        title = "title" <~~ json
    }
    
    open func toJSON() -> Gloss.JSON? {
        return jsonify([
            "company-token" ~~> company,
            "company_department" ~~> companyDepartment,
            "date_createdme" ~~> dateCreated,
            "date_modified" ~~> dateModified,
            "description" ~~> description,
            "id" ~~> id,
            "is_active" ~~> isActive,
            "is_deleted" ~~> isDeleted,
            "news_category_info" ~~> newsCategoryInfo,
            "news_category_name" ~~> newsCategoryName,
            "title" ~~> title
            
            ])
    }
}

open class NewsPageInfoData: Glossy {
    
    open var currentPage: Int?
    open var perPage: Int?
    open var totalFound: Int?

    required public init?(json: Gloss.JSON) {
        currentPage = "current_page" <~~ json
        perPage = "per_page" <~~ json
        totalFound = "total_found" <~~ json
        
    }
    
    open func toJSON() -> Gloss.JSON? {
        return jsonify([
            "current_page" ~~> currentPage,
            "per_page" ~~> perPage,
            "total_found" ~~> totalFound,
            
            ])
    }
}


open class ThreadsData: Glossy {
    
    open var authId: String?
    open var fullName: String?
    open var thread_id: Int?
    open var initiatedBy: Int?
    open var isMute: Bool?
    open var isPin: Bool?
    open var isSeen: Bool?
    open var lastMessage: String?
    open var lastUpdated: String?
    open var title: String?
    open var type: String?
    open var userId: Int?
    open var user_image_large: String?
    open var user_image_thumb: String?
    

    required public init?(json: Gloss.JSON) {
        authId = "auth_id" <~~ json
        fullName = "full_name" <~~ json
        thread_id = "thread_id" <~~ json
        initiatedBy = "initiated_by" <~~ json
        isMute = "is_mute" <~~ json
        isPin = "is_pinned" <~~ json
        isSeen = "is_seen" <~~ json
        lastMessage = "last_message" <~~ json
        lastUpdated = "last_updated" <~~ json
        title = "title" <~~ json
        type = "type" <~~ json
        userId = "user_id" <~~ json
        user_image_large = "user_image_thumb" <~~ json
        user_image_thumb = "user_image_thumb" <~~ json
        
    }
    
    open func toJSON() -> Gloss.JSON? {
        return jsonify([
            "auth_id" ~~> authId,
            "full_name" ~~> fullName,
            "thread_id" ~~> thread_id,
            "initiated_by" ~~> initiatedBy,
            "is_mute" ~~> isMute,
            "is_pinned" ~~> isPin,

            "is_seen" ~~> isSeen,
            "last_message" ~~> lastMessage,
            "last_updated" ~~> lastUpdated,

            "title" ~~> title,
            "type" ~~> type,
            "user_id" ~~> userId,
            "user_image_thumb" ~~> user_image_large,
            "user_image_thumb" ~~> user_image_thumb,
            
            
            ])
    }

}

open class AllThreadsData: Glossy {
    
    open var current_page:Double?
    open var per_page:Double?
    open var threads:[ThreadsData]?
    
    required public init?(json: Gloss.JSON) {
        current_page = "current_page" <~~ json
        per_page = "per_page" <~~ json
        threads = "threads" <~~ json

    }
    
    open func toJSON() -> Gloss.JSON? {
        return jsonify([
            "current_page" ~~> current_page,
            "per_page" ~~> per_page,
            "threads" ~~> threads,
            ])
    }

}

open class ThreadMessageData: Glossy {
    
    open var content:Dictionary<String, Any>?//have to change it
    open var content_type:String?
    open var date_created:String?
    open var deleted_time:String?
    open var full_name:String?
    open var is_deleted:Bool?
    open var message:String?
    open var message_id:Int?
    open var sent_by:Int?
    open var user_image_thumb:String?
    open var authId:String?
    
    required public init?(json: Gloss.JSON) {
        content = "content" <~~ json
        content_type = "content_type" <~~ json
        date_created = "date_created" <~~ json
        deleted_time = "deleted_time" <~~ json
        full_name = "full_name" <~~ json
        is_deleted = "is_deleted" <~~ json
        message = "message" <~~ json
        message_id = "message_id" <~~ json
        sent_by = "sent_by" <~~ json
        user_image_thumb = "user_image_thumb" <~~ json
        authId = "auth_id" <~~ json
        
    }
    
    open func toJSON() -> Gloss.JSON? {
        return jsonify([
            "content" ~~> content,
            "content_type" ~~> content_type,
            "date_created" ~~> date_created,
            "deleted_time" ~~> deleted_time,
            "full_name" ~~> full_name,
            "is_deleted" ~~> is_deleted,

            "message" ~~> message,
            "message_id" ~~> message_id,
            "sent_by" ~~> sent_by,
            "user_image_thumb" ~~> user_image_thumb,
            "auth_id" ~~> authId,
            
            ])
    }
    
}
