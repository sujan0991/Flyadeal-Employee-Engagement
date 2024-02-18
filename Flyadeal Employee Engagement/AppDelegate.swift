//
//  AppDelegate.swift
//  Flyadeal Employee Engagement
//
//  Created by Md.Ballal Hossen on 11/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import Auth
import Common
import News
import Firebase
import UserNotifications
import FirebaseMessaging
import SwiftKeychainWrapper
import Inbox
import IQKeyboardManagerSwift
import Events
import StaffDirectory
import Feed

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true

       
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate

        //check if 1st launch
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
        }
        else
        {
            print("First launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            //delete refreshToken from keychain
            KeychainWrapper.standard.remove(key: "refreshToken")
            KeychainWrapper.standard.remove(key: "accessToken")
            KeychainWrapper.standard.remove(key: "fcmToken")
            
        }
        //end checking
        
        
        //set rootvie based on login status
        if KeychainWrapper.standard.hasValue(forKey: "refreshToken"){
            
            print("Logged in")
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "ParenTabViewController") as! ParenTabViewController
            
            
            appDelegate.window?.rootViewController = mainTabBarController

            
        }else{
            
            print("Not Logged In")
            
            let s = UIStoryboard (
                name: "Auth", bundle: Bundle(for: LoginViewController.self)
            )
            let vc = s.instantiateInitialViewController() as! UIViewController
            

            appDelegate.window?.rootViewController = vc
            
            
        }
        
        //*****end setting rootview
        
        
        //Register  navigation on App Launch
        
        Router.default.setupAppNavigation(appNavigation: MyAppNavigation())
        
        //******
        
        
        //Firebase Config
        FirebaseApp.configure()

        //remote Notification Setup
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]

        
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        return true
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }


    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
      //  SocketIOManager.sharedInstance.closeConnection()

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginSuccess(_:)), name: NSNotification.Name(rawValue: "logindone"), object: nil)
        
      //  SocketIOManager.sharedInstance.establishConnection()

        print("applicationDidBecomeActive")
      
    }

   
    
    // Set rooviewcontroller after login
    @objc func loginSuccess(_ notification: NSNotification) {
        
        print("loginSuccess")
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "ParenTabViewController") as! ParenTabViewController
        
        
        appDelegate.window?.rootViewController = mainTabBarController

        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    struct MyAppNavigation: AppNavigation {
        
        func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController {
            //            if let navigation = navigation as? MyNavigation {
            //
            //                switch navigation {
            //                case .newsDetail:
            //                    return NewsDetailsViewController()
            ////                case .profile(let p):
            ////                    return ProfileViewController(person: p)
            //                }
            //            }
            return UIViewController()
        }
        
        func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController, info:Dictionary<String, Any>) {
            
            print("navigate in appdelegate",info)
            
            if let navigation = navigation as? MyNavigation {
                
                switch navigation {
                case .newsDetail:
                    
                    let storyBoard = UIStoryboard(name: "News", bundle: Bundle(for: NewsViewController.self ))
                    
                    let vc :NewsDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "NewsDetailsViewController") as! NewsDetailsViewController
                    vc.newsId = info["newsId"] as! String
                    from.navigationController?.pushViewController(vc, animated: true)
                 
                case .logOut:
                    
                    KeychainWrapper.standard.remove(key: "refreshToken")
                    KeychainWrapper.standard.remove(key: "accessToken")

                    let storyBoard: UIStoryboard = UIStoryboard.init(name: "Auth", bundle:Bundle(for: LoginViewController.self))
                    let vc :LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate

                    appDelegate.window?.rootViewController = vc
                    
                case .forgetPassword:
                    
                    let storyBoard = UIStoryboard(name: "Auth", bundle: Bundle(for: LoginViewController.self ))
                    
                    let vc :ForgetPasswordViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
                   
                    from.navigationController?.pushViewController(vc, animated: true)
                case .eventsDetail:
                    
                    let storyBoard = UIStoryboard(name: "Events", bundle: Bundle(for: EventListViewController.self ))
                    
                    let vc :EventDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
                   // vc.newsId = info["newsId"] as! String
                    from.navigationController?.pushViewController(vc, animated: true)
                case .staffList:
                    
                    
                    print("from view controller ",from)
                    
                    let storyBoard = UIStoryboard(name: "StaffDirectory", bundle: Bundle(for: StaffListViewController.self ))
                    
                    let vc :StaffListViewController = storyBoard.instantiateViewController(withIdentifier: "StaffListViewController") as! StaffListViewController
                    // vc.newsId = info["newsId"] as! String
                    
                    from.navigationController?.pushViewController(vc, animated: true)
                    
                case .profile:
                    
                    
                    print("from view controller ",from)
                    
                    let storyBoard = UIStoryboard(name: "StaffDirectory", bundle: Bundle(for: StaffListViewController.self ))
                    
                    let vc :ProfileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                     vc.userId = info["authId"] as! String
                    
                    from.navigationController?.pushViewController(vc, animated: true)
                    


                }
            }
            
            
            
        }
    }


}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
       
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        
        //save fcmToken to keychain
         KeychainWrapper.standard.set(fcmToken, forKey: "fcmToken")
        
    }
    // [END refresh_token]
    
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


