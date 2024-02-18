//
//  APIManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Gloss
import SVProgressHUD
import SwiftKeychainWrapper


extension String{
    func isTrue() -> Bool {
        return self == "True"
    }
}

enum RequestActionType:String {
    case accept = "add"
    case reject = "cancel"
    case remove = "remove"
}
enum RequestAction:String {
    case accept = "accepted"
    case reject = "rejected"
}

struct API_ENDPOINT {
    
    static let DEVICE_TYPE = "iOS"
    static let API_ENDPOINTEY = "base64:8WGdd0uX3GtRtTxeOyuHd3864Mqfc6C/cbhzpEZUdxA="
    
    static let BaseUrlStr:String = "http://45.55.41.166/"
    
    static let BaseURL = URL(string:"\(BaseUrlStr)api/v1/")!
    
    static let LOGIN = "auth/login"//
    static let REFRESH_TOKEN = "auth/refresh-token"
    
    static let RESET_PASS = "auth/reset-password"

    static let ALL_NEWS = "news"

    static let ALL_THREADS = "threads"
    
    static let STAFF_LIST = "users"
    


    static let LOGOUT = "logout"//

    static let REGISTER = "registration"

}

struct API_STRING {
    
    static let  PROPILE_REVIEW_ALERT = "Please set up your profile"
    
    static let  LOGIN_VALIDATION_TEXT = "The duplicate key value is"
    
    static let  NOTE_ADD_SUCCESS = "Note sent successfully"
    static let  COMMENT_ADD_SUCCESS = "Feedback sent successfully"
    static let  POST_ADD_SUCCESS = "Upload ad successful"
    static let  POST_ADD_FAIL = "Upload ad failed"

    static let  POST_EDIT_SUCCESS = "Post edited successfully"
    static let  POST_EDIT_FAIL = "Post edit failed"

    static let  NOTE_ADD_FAIL = "Note sending failed"
    static let  COMMENT_ADD_FAIL = "Feedback sending failed"
    
    static let  DELETE_ADD_SUCCESS = "Ad delete successful"
    static let  DELETE_ADD_FAIL = "Ad delete failed"
}

struct APP_STRING {
   
    static let  SERVER_ERROR = "Something went wrong! Please, try later"
    static let PROGRESS_TEXT = "Please wait..."
    static let CommentPlaceHolder = "Write your comment"
    static let PostPlaceHolder = "Details"
    static let CategoryPlaceHolder = "Category"
    static let notePlaceHolder = "Write your note"
    static let EmptyDataText = "No ads are available"
}

enum ResponseType {
    case success
    case fail
    case invalid
}

public class APIManager: NSObject {
    
    /*
     *-------------------------------------------------------
     * MARK:- singletone initialization
     *-------------------------------------------------------
     */
    
    private struct Static {
        static var intance: APIManager? = nil
    }
    
    private static var __once: () = {
        Static.intance = APIManager()
    }()
    
    public class var manager: APIManager {
        _ = APIManager.__once
        return Static.intance!
    }
    
   public func login(email:String, password:String, withCompletionHandler completion:(( _ userMetaData: UserMetaData?, _ message: String?)->Void)?) {
        
      SVProgressHUD.show()
    
        
        let params:[String:Any] = [
                                      "domain":"flowdigital.com",
                                      "email":email,
                                      "password":password,                      "device_id":KeychainWrapper.standard.string(forKey: "fcmToken")!,
                                      "is_notifiable":true
                                      
                                    ]
    
    postDataModel(params, method: API_ENDPOINT.LOGIN) { (dataModel,msg) in
        
        if msg == "Login Successful"{
            
            if let jsA = dataModel{
                if let histories = UserMetaData.init(json: jsA) {
                    
                    let params:[String:Any] = [
                        "refresh_token":histories.refreshToken ?? "",
                        "device_id":KeychainWrapper.standard.string(forKey: "fcmToken")!,
                        "is_notifiable":true
                    ]
                    
                    UserDefaults.standard.setValue(histories.userId ?? "", forKey: "userId")
                    
                    self.postDataModel(params, method: API_ENDPOINT.REFRESH_TOKEN) { (dataModel,msg) in
                        
                        if let jsA = dataModel{
                            if let histories = UserMetaData.init(json: jsA) {
                                
                                SVProgressHUD.dismiss()
                                
                                completion?(histories,msg)
                                
                            } else {
                                
                                completion?(nil,msg)
                            }
                        }
                    }

                } else {
                    completion?(nil,msg)
                }
            }
            else{
                completion?(nil,msg)
            }

        }

    }
 
    }
    
    public func passwordRequest(email:String , withCompletionHandler completion:(( _ message: String?)->Void)?) {
        
        SVProgressHUD.show()
        
        let params:[String:Any] = [
            "email":email
        ]

        self.getDataModel(params, method: API_ENDPOINT.RESET_PASS) { (dataModel,msg) in
            
//             if let jsA = dataModel{
//
//
//            }
            
            completion?(msg)
             SVProgressHUD.dismiss()
        }
        
    }

    
    
    public func allNews(title:String ,page:Int, withCompletionHandler completion:(( _ allnewsData: [NewsData]?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show()
        
        let params:[String:Any] = [
            "title":title,
            "page":page,
            "per_page":10,
        ]
        
        print("params",params)
        
        
        getDataModelWithAuthorization(params, method: API_ENDPOINT.ALL_NEWS) { (dataModel,msg) in
            
            print("getDataModelWithAuthorization in allNews msg",msg)
            SVProgressHUD.dismiss()
            
            if msg == "Logout" {
            
                completion?([],msg)
                
            }else if msg == "OK" {
                
                completion?([],"Unauthorized Access")
                
            }else if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    //  print("getDataModelWithAuthorization news",jsA)
                    
                    let tempArray = JSON(jsA)
                    if let newsArray = tempArray["news_list"].arrayObject as? [Gloss.JSON]{
                        
                        if let news = [NewsData].from(jsonArray: newsArray) {
                            
                            print("news.count",news.count)
                            completion?(news,msg)
                            
                        } else {
                            
                            print("news.count none")
                            completion?([],msg)
                            
                        }
                    }
                    
                }

                
            }
        }
        
    }
    
    public func singleNews(id:String , withCompletionHandler completion:(( _ singlenewsData: NewsData?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show()
     
        getDataModelWithAuthorization(nil, method: API_ENDPOINT.ALL_NEWS+"/"+id) { (dataModel,msg) in
            if msg != "Unauthorized Access"{
                
                if let jsA = dataModel{
                    
                    //  print("getDataModelWithAuthorization news",jsA)
                    
                    let tempArray = JSON(jsA)
                    
                    if let histories = NewsData.init(json: jsA) {
                        
                       completion?(histories,msg)
                        
                        SVProgressHUD.dismiss()
                        
                    }
                    
                }
            }else{
                
                completion?(nil,msg)
            }
        }
        
    }
    
    
    
    
    public func allThreads(withCompletionHandler completion:(( _ allThreadsData: AllThreadsData?, _ message: String?)->Void)?) {
        
//        SVProgressHUD.show()
        
        getDataModelWithAuthorization(nil, method: API_ENDPOINT.ALL_THREADS) { (dataModel,msg) in
            
           // print("getDataModelWithAuthorization in allThreads msg",msg)
            
            if msg == "Logout" {
                
                completion?(nil,msg)
                
            }else if msg == "OK" {
                
                completion?(nil,"Unauthorized Access")
                
            }else if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                   // print("getDataModelWithAuthorization allthreads",tempArray)
                    
                    if let histories = AllThreadsData.init(json: jsA) {
                        
                      //  print("getDataModelWithAuthorization threads????????",histories.per_page)
                        
                        completion?(histories,msg)
                    }

                    
                }
                
                
            }
        }
        
    }
    
    public func initiateThread(id:String , withCompletionHandler completion:(( _ threadId: String?, _ message: String?)->Void)?) {
        
     //   SVProgressHUD.show()
        
        let params:[String:Any] = [
            "peer_id":id,
        ]
        
      //  print("params",params)

        postDataModelWithAuthorization(params, method: API_ENDPOINT.ALL_THREADS) { (dataModel,msg) in
            
            print("getDataModelWithAuthorization in initiateThread msg",msg!)
            
            if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                    let threadId:String  = tempArray["thread_id"].stringValue
                    
                    completion?(threadId,msg)
                }
                
                
            }else{
                
                completion?(nil,msg)
            }
        }
        
    }
    
    
    
    public func getMessagesOfThread(threadId:String,pageNo:Int, withCompletionHandler completion:(( _ allMessages:[ThreadMessageData],_ token:String?,_ userId:String?,_ file_storage_base:String?,_ current_page: Int?, _ message: String?)->Void)?) {
        
     //   SVProgressHUD.show()
        
        let params:[String:Any] = [
            "page":pageNo,
            "per_page":15,
        ]
        
        getDataModelWithAuthorization(params, method: API_ENDPOINT.ALL_THREADS + "/" + threadId) { (dataModel,msg) in
            
         //   print("getDataModelWithAuthorization in allThreads msg",msg)
            
            if msg == "Logout" {
                
                //completion?(nil,msg)
                
            }else if msg == "OK" {
                
                //completion?(nil,"Unauthorized Access")
                
            }else if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                    let token:String = tempArray["access_token"].stringValue
                   
                    let userId:String = tempArray["current_user_id"].stringValue
                    let file_storage_base:String = tempArray["file_storage_base"].stringValue
                    let current_page = tempArray["current_page"].intValue
                  
                     // print("getDataModelWithAuthorization Messages",tempArray)
                  //  if let jsonDic = tempArray.dictionaryObject {
                        
                        
                        
                        if let messagesArray = tempArray["thread_messages"].arrayObject as? [Gloss.JSON]{
                            
                            if let messages = [ThreadMessageData].from(jsonArray: messagesArray) {
                                
                                print("messages count",messages.count)
                                completion?(messages,token,userId,file_storage_base,current_page,msg)
                                
                            } else {
                                
                                print("messages count none")
                                completion?([],token,userId,file_storage_base,current_page,msg)
                                
                            }
                        }
//                        completion?([],nil,msg)
//                    }
                    
                    
                    
                }
                
                
            }
        }
        
    }
    
    public func postMessagesOfThread(threadId:String,params:Dictionary<String, Any>, withCompletionHandler completion:(( _ sendMsgDic: Dictionary<String, Any>, _ message: String?)->Void)?) {
        
    //    SVProgressHUD.show()
        
        let params:[String:Any] = params
        
        
        postDataModelWithAuthorization(params, method: API_ENDPOINT.ALL_THREADS + "/" + threadId) { (dataModel,msg) in
            
            print("getDataModelWithAuthorization in initiateThread msg",msg!)
            
            if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                    if let jsonDic = tempArray.dictionaryObject {
                        
                        completion?(jsonDic,msg)
                    }
                    
                }
                
                
            }
        }
        
    }
    
    public func updateMessagesOfThread(threadId:String,isPined:Int, withCompletionHandler completion:(( _ sendMsgDic: Dictionary<String, Any>, _ message: String?)->Void)?) {
        
        
        let isPin = Bool(isPined as NSNumber)
        
        let params:[String:Any] =  [
                    "pin":isPin,
                    ]
        
        
        patchDataModelWithAuthorization(params, method: API_ENDPOINT.ALL_THREADS + "/" + threadId) { (dataModel,msg) in
            
            print("updateMessagesOfThread in initiateThread msg",msg!)
            
            if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                    if let jsonDic = tempArray.dictionaryObject {
                        
                        completion?(jsonDic,msg)
                    }
                    
                }
                
                
            }
        }
        
    }
    
    public func postMediaMessagesOfThread(threadId:String,mediaInfo:Dictionary<String, Any>, params:Dictionary<String, Any>, withCompletionHandler completion:(( _ sendMsgDic: Dictionary<String, Any>, _ message: String?)->Void)?) {
        
        SVProgressHUD.show()
        
        
       
        let urlString = "http://45.55.41.166/api/v1/threads" + "/" + threadId + "/" + "media"
        
        let params:[String:Any] = params
        
        print("mediaInfo....",mediaInfo)
        
        var header: HTTPHeaders = [:]
        
        if let authToken = KeychainWrapper.standard.string(forKey: "accessToken"){
            //print("authToken",authToken)
            header["Authorization"] = "PULSE \(authToken)"
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            if mediaInfo["fileType"] as! String == "image"{
           
                let image = mediaInfo["image"] as! UIImage
                
               guard let imgData = image.jpegData(compressionQuality: 0.3) else { return }
               multipartFormData.append(imgData, withName: "file", fileName:"Image.jpeg", mimeType: "image/jpeg")
                
            }else if mediaInfo["fileType"] as! String == "pdf" {
                
                print("pdf..................")
                let name = mediaInfo["name"] as! String
                let url = mediaInfo["url"] as! URL
                
                let pdfData = try! Data(contentsOf: url)
                //var data : Data = pdfData
                
                multipartFormData.append(pdfData, withName: "file", fileName: name, mimeType:"application/pdf")
                
                
            }
            
        
            
        },usingThreshold: UInt64.init(),
          to: urlString,
          method: .post,
          headers: header).response{ response in
            
        print("//////response.request",response.request!.httpBody)
            
            print("//////response",response.response?.statusCode)
            switch response.result {
            case .success(let value):
                
                print("suddecc......",value)
                let json = JSON(value)
                
                print("getPostDataModel...... ",json)
                
            case .failure(let error):
                
                print("error",error.localizedDescription)
            }
            
            SVProgressHUD.dismiss()
            
            }
            
        
        
    }
    
    public func getStaffList(c_Name:String,page_no:Int, withCompletionHandler completion:(( _ dataDic: Dictionary<String, Any>, _ message: String?)->Void)?) {
        
        //    SVProgressHUD.show()
        
        let params:[String:Any] = ["":c_Name,
                                   "page":page_no,
                                   "per_page":20,]
        
        
        getDataModelWithAuthorization(params, method: API_ENDPOINT.STAFF_LIST) { (dataModel,msg) in
            
            print("getDataModelWithAuthorization in initiateThread msg",msg!)
            
            if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                    if let jsonDic = tempArray.dictionaryObject {
                        
                        completion?(jsonDic,msg)
                    }
                    
                }
                
                
            }
        }
        
    }
    
    public func getUserInfo(id:String, withCompletionHandler completion:(( _ dataDic: Dictionary<String, Any>, _ message: String?)->Void)?) {
        
        //    SVProgressHUD.show()
        
        getDataModelWithAuthorization(nil, method: API_ENDPOINT.STAFF_LIST + "/\(id)") { (dataModel,msg) in
            
            print("getDataModelWithAuthorization in initiateThread msg",msg!)
            
            if msg != "Unauthorized Access" {
                
                if let jsA = dataModel{
                    
                    
                    let tempArray = JSON(jsA)
                    
                    if let jsonDic = tempArray.dictionaryObject {
                        
                        completion?(jsonDic,msg)
                    }
                    
                }
                
                
            }
        }
        
    }
    
        
    
    func getAccessToken (withCompletionHandler completion:((_ message: String?)->Void)?) {
        
        let params:[String:Any] = [
            "refresh_token":KeychainWrapper.standard.string(forKey: "refreshToken")!,
            "device_id":KeychainWrapper.standard.string(forKey: "fcmToken")!,
            "is_notifiable":true
        ]
        
        Request(.post, API_ENDPOINT.REFRESH_TOKEN, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            
            
            switch responseData.result {
            case .success(let value):
                
                print("responseData.response?.statusCode ",responseData.response?.statusCode)
                
                if let httpStatusCode = responseData.response?.statusCode {
                    
                    switch(httpStatusCode) {
                    case 401:
                        
                        print("refress token expire,so logout")
                       
                        completion?("Logout")
                        
                    default:
                        
                        let json = JSON(value)
                        
                        
                        if let jsonDic = json.dictionaryObject {
                            
                            let msg:String = json["message"].stringValue
                            
                            if let locationsArray = json["data"].dictionaryObject {
                                
                                let refressToken = locationsArray["refresh_token"] as! String
                                let accessToken = locationsArray["access_token"] as! String
                                
                                //save refresh token to keychain
                                KeychainWrapper.standard.set(refressToken , forKey: "refreshToken")
                                KeychainWrapper.standard.set(accessToken , forKey: "accessToken")
                                
                                completion?("OK")
                            }
                            
                        }

                    }
                }

            case .failure(let error):
                
                print(error.localizedDescription)
                
            }
        })

        
    }
 
    func postDataModel(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ data: Gloss.JSON?,_ msg:String?)->Void)?) {
        
        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
               
                let json = JSON(value)
                
                print("getPostDataModel ",json)
                
                if let jsonDic = json.dictionaryObject {
                    
                        let msg:String = json["message"].stringValue
                    
                        if let locationsArray = json["data"].dictionaryObject {
                            
                            completion?(locationsArray,msg)
                            
                        }
                        else{
                            completion?(nil,msg)
                        }
                    
                }
                else {
                    completion?(nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                
                completion?(nil,error.localizedDescription)
            }
        })
    }
   
    func postDataModelWithAuthorization(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:((_ data: Gloss.JSON?,_ msg:String?)->Void)?) {
        
        print("params",param)
        
        RequestWithAuthorizationForRawParameter(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                
                let json = JSON(value)
                
                print("getPostDataModelWithAuthorization ",json,responseData.response?.statusCode)
                
                if let jsonDic = json.dictionaryObject {
                    
                    let msg:String = json["message"].stringValue
                    
                    if let locationsArray = json["data"].dictionaryObject {
                        
                      //  SVProgressHUD.dismiss()

                        completion?(locationsArray,msg)
                    }
                    else{
                        
                      //  SVProgressHUD.dismiss()

                        completion?(nil,msg)
                    }
                    
                }
                else {
                  //  SVProgressHUD.dismiss()

                    completion?(nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                
                SVProgressHUD.dismiss()

                completion?(nil,error.localizedDescription)
            }
        })
    }
    
    func patchDataModelWithAuthorization(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:((_ data: Gloss.JSON?,_ msg:String?)->Void)?) {
        
        print("params",param)
        
        RequestWithAuthorizationForRawParameter(.patch, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                
                let json = JSON(value)
                
                print("patchDataModelWithAuthorization ",json,responseData.response?.statusCode)
                
                if let jsonDic = json.dictionaryObject {
                    
                    let msg:String = json["message"].stringValue
                    
                    if let locationsArray = json["data"].dictionaryObject {
                        
                     //   SVProgressHUD.dismiss()
                        
                        completion?(locationsArray,msg)
                    }
                    else{
                        
                     //   SVProgressHUD.dismiss()
                        
                        completion?(nil,msg)
                    }
                    
                }
                else {
                  //  SVProgressHUD.dismiss()
                    
                    completion?(nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                
                SVProgressHUD.dismiss()
                
                completion?(nil,error.localizedDescription)
            }
        })
    }

    func getDataModel(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:((_ data: Gloss.JSON?,_ msg:String?)->Void)?) {
       // SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        print("params.....",param!)
        
        RequestForGet(.get, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            
            switch responseData.result {
            case .success(let value):
               
              //  SVProgressHUD.dismiss()
                let json = JSON(value)
                 print("responseData json",json)
                if let jsonDic = json.dictionaryObject {
                    
                   
                    let msg:String = json["message"].stringValue
                    
                    if msg != "Unauthorized Access"{
                        
                        if let tempArray = json["data"].dictionaryObject {
                            completion?(tempArray,msg)
                        }
                        else{
                            completion?(nil,msg)
                        }

                    }else{
                        
                        print("Unauthorized Access")
                        completion?(nil,msg)
                       // self.getAccessToken()
                    }
                    
                    
                }
                else {
                    completion?(nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
             //   SVProgressHUD.dismiss()
                completion?(nil,error.localizedDescription)
            }
        })
    }

    func getDataModelWithAuthorization(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:((_ data: Dictionary<String, Any>?,_ msg:String?)->Void)?) {
        // SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
       // print("params",param!)

        RequestWithAuthorization(.get, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            
            switch responseData.result {
            case .success(let value):
                
//                  SVProgressHUD.dismiss()
                let json = JSON(value)
                
                 print("responseData json",json)
                
                if let jsonDic = json.dictionaryObject {
                    
                    let msg:String = json["message"].stringValue
                    
                    print("msg ??????",msg)
                    
                    if msg != "Unauthorized Access"{
                        
                        if let tempArray = json["data"].dictionaryObject {
                            
                            completion?(tempArray,msg)
                        }
                        else{
                            completion?(nil,msg)
                        }

                        
                        
                    }else{
                        
                        self.getAccessToken{(msg) in
                            
                            print("getAccessToken msg.......??????",msg!)
                            if msg == "Logout"{
                                
                               
                               print("Logout.......??????")
                               completion?(nil,msg)
                                
                            }else{
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    
                                    completion?(nil,msg)
                                    print("Unauthorized Access.......")
                                    
                                }
                            }
                            
                        }
                        
                        
                        
                        
                    }
                }
                else {
                    completion?(nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                   SVProgressHUD.dismiss()
                completion?(nil,error.localizedDescription)
            }
        })
    }

}
