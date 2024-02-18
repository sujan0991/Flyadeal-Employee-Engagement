//
//  EventsViewController.swift
//  Events
//
//  Created by Md.Ballal Hossen on 14/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import DTPagerController
import Common

public class EventsViewController: UIViewController,DTSegmentedControlProtocol,DTPagerControllerDelegate  {
    public var selectedSegmentIndex: Int = 0
    

    

    var containerView = UIView()
    
    @IBOutlet weak var navImage: UIImageView!
    @IBOutlet weak var navView: UIView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let someFloat = CGFloat(self.view.frame.height)
        
        containerView = UIView(frame: CGRect(x: 0, y:UIApplication.shared.statusBarFrame.height + navView.frame.height ,width: UIScreen.main.bounds.size.width,height: someFloat - (UIApplication.shared.statusBarFrame.height + navView.frame.height) ))
        
       
        self.view.addSubview(containerView)
        
        let storyBoard = UIStoryboard(name: "Events", bundle: Bundle(for: EventsViewController.self ))
        
        let vc1 :EventListViewController = storyBoard.instantiateViewController(withIdentifier: "EventListViewController") as! EventListViewController
        vc1.title = "UPCOMING"
        vc1.eventType = .upcoming
        
        let vc2 :EventListViewController = storyBoard.instantiateViewController(withIdentifier: "EventListViewController") as! EventListViewController
        vc2.title = "MY EVENTS"
        vc2.eventType = .myEvent
        
        let vc3 :EventListViewController = storyBoard.instantiateViewController(withIdentifier: "EventListViewController") as! EventListViewController
        vc3.title = "PAST"
        vc3.eventType = .past
        
        
        let pagerController = DTPagerController(viewControllers: [vc1, vc2,vc3])
        customizeSegment(pagerController: pagerController)
        
        pagerController.delegate = self
        
        addChild(pagerController)
        pagerController.view.frame = containerView.bounds
        print(pagerController.view)
        containerView.addSubview(pagerController.view)
        pagerController.didMove(toParent: self)

        
        
    }
    
    func customizeSegment(pagerController: DTPagerController)
    {
        
        pagerController.preferredSegmentedControlHeight = 30
        //   pagerController.font = UIFont.systemFont(ofSize: 15)
        //   pagerController.selectedFont = UIFont.boldSystemFont(ofSize: 15)
        pagerController.textColor = UIColor.gray
        pagerController.selectedTextColor = UIColor("#411D59")
        
        pagerController.perferredScrollIndicatorHeight = 2
        pagerController.scrollIndicator.layer.cornerRadius = pagerController.scrollIndicator.frame.height/2
        pagerController.scrollIndicator.backgroundColor = UIColor("#D7D809")
        pagerController.pageSegmentedControl.backgroundColor = UIColor.white
        
    }

    
    public func setTitle(_ title: String?, forSegmentAt segment: Int) {
        
    }
    
    public func setImage(_ image: UIImage?, forSegmentAt segment: Int) {
        
    }
    
    public func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State) {
        
    }

}
