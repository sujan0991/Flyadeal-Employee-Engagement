//
//  Router.swift
//  Router


import UIKit

public enum EventType:Int {
    case upcoming = 0
    case myEvent = 1
    case past = 2
}


public enum MyNavigation: Navigation {
    case newsDetail
    case logOut
    case forgetPassword
    case eventsDetail
    case staffList
    case profile
    //        case profile(Person)
}

//***********//Register  navigation on App Launch(Appdelegate)

public class Router {
    
    public static let `default`:IsRouter = DefaultRouter()
}

public protocol Navigation { }

public protocol AppNavigation {
    
    func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController
    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController, info:Dictionary<String, Any>)
}

public protocol IsRouter {
    func setupAppNavigation(appNavigation: AppNavigation)
    func navigate(_ navigation: Navigation, from: UIViewController,info:Dictionary<String, Any>)
    func didNavigate(block: @escaping (Navigation) -> Void)
    var appNavigation: AppNavigation? { get }
}

public extension UIViewController {
    
    public func navigate(_ navigation: Navigation,from:UIViewController, info:Dictionary<String, Any>) {
        print("extension UIViewController in Route",from)
        Router.default.navigate(navigation, from: self, info: info)
    }
}

public class DefaultRouter: IsRouter {
    
    public var appNavigation: AppNavigation?
    var didNavigateBlocks = [((Navigation) -> Void)] ()
    
    public func setupAppNavigation(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
    
    public func navigate(_ navigation: Navigation, from: UIViewController, info:Dictionary<String, Any>) {
        
        print("DefaultRouter: IsRouter in Route")
        
        if let toVC = appNavigation?.viewcontrollerForNavigation(navigation: navigation) {
            appNavigation?.navigate(navigation, from: from, to: toVC,info:info)
            for b in didNavigateBlocks {
                b(navigation)
            }
        }
    }
    
    public func didNavigate(block: @escaping (Navigation) -> Void) {
        didNavigateBlocks.append(block)
    }
}

// Injection helper
public protocol Initializable { init() }
open class RuntimeInjectable: NSObject, Initializable {
    public required override init() {}
}

public func appNavigationFromString(_ appNavigationClassString: String) -> AppNavigation {
    let appNavClass = NSClassFromString(appNavigationClassString) as! RuntimeInjectable.Type
    let appNav = appNavClass.init()
    return appNav as! AppNavigation
}

