//
//  AppSessionManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import Alamofire
//import SVProgressHUD

final class AppSessionManager: NSObject, Glossy {
    
    var currentUser: UserModel?
    var authToken:String?

    //---------------------------------------------------
    // MARK: - Gloss - Decodable
    //---------------------------------------------------
    
    required init?(json:Gloss.JSON) {
     
        // property initializations
        currentUser = "currentUser" <~~ json
        authToken = "authToken" <~~ json

        super.init()
    }

    deinit {
        save()
        NotificationCenter.default.removeObserver(self)
        // anything needed to deinit
    }
    
    class var shared: AppSessionManager {
        return Static._session
    }
    
    //--------------------------------------------------------------
    //MARK: - Private
    //--------------------------------------------------------------
    
    fileprivate struct Static {
        static var _session:AppSessionManager  = AppSessionManager.getSavedInstance() ?? AppSessionManager(json: [:])!
    }
    
    //---------------------------------------------------
    // MARK: - Gloss - Encodable
    //---------------------------------------------------
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "currentUser" ~~> currentUser,
            "authToken" ~~> authToken
            ])
    }
    
    //---------------------------------------------------
    // MARK: - Singleton
    //---------------------------------------------------
    
    static func getSavedInstance()->AppSessionManager? {
        if let savedData = (try? NSString(contentsOfFile: AppSessionManager.saveFilePath(), encoding: String.Encoding.utf8.rawValue)) as String? {
            //println("sdsds \(savedData)")
            let  objectData = savedData.data(using: String.Encoding.utf8)!
            var json:Gloss.JSON?
            do {
                json = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as? Gloss.JSON
            } catch { print("Failed to parse saved string for session")}
            if let json = json,  let storedInstance = AppSessionManager(json: json) {
                return storedInstance
            }
        }
        
        return nil
    }
    
    //---------------------------------------------------
    // MARK: - Consistency
    //---------------------------------------------------
    
    func save() {
        if let str = jsonString(false) {
            do {
                try str.write(toFile: AppSessionManager.saveFilePath(), atomically: true, encoding: String.Encoding.utf8)
            } catch { print("Failed to save session") }
        } else {
            print("Failed to create jsonString from session")
        }
    }
    
    static func saveFilePath() -> String {
        
        let folder: String = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!
        
        if !FileManager.default.fileExists(atPath: folder) {
            do {
                try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
        
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        return (folder as NSString).appendingPathComponent("\(className).json")
    }
    
    func jsonString(_ prettyPrint:Bool)->String? {
        var err: NSError?
        let JSONDict = self.toJSON()!
        if JSONSerialization.isValidJSONObject(JSONDict) {
            let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
            var JSONData: Data? = nil
            do {
                JSONData = try JSONSerialization.data(withJSONObject: JSONDict, options: options)
            } catch let error as NSError {
                err = error
                JSONData = nil
            } catch {}
            
            if let error = err {
                print(error)
            }
            
            if let JSON = JSONData {
                return NSString(data: JSON, encoding: String.Encoding.utf8.rawValue) as String?
            }
        }
        
        return nil
    }
    
    func navigateToHome() {
        
        let sb: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateInitialViewController()
        
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = vc
        }
    }
    
    func navigateWith(sbID:String,from:UIViewController) {
        
        let sb: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier:sbID)
       from.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func navigateOtherProfile(_ user:UserModel,from:UIViewController) {
//        
//        let sb: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//        let vc:OtherProfileVC = sb.instantiateViewController(withIdentifier:"OtherProfileVC") as! OtherProfileVC
//        
//        vc.user = user
//        from.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func navigateAuth() {
        let sb: UIStoryboard = UIStoryboard.init(name: "Auth", bundle: Bundle.main)
        let vc = sb.instantiateInitialViewController()
        
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = vc
        }
    }
    
    func logOut() {
        
        AppSessionManager.shared.currentUser = nil
        AppSessionManager.shared.authToken = nil
        AppSessionManager.shared.save()
        
        let sb: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateInitialViewController()
        
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = vc
        }
    }
}
