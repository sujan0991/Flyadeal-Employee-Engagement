//
//  EventDetailsViewController.swift
//  Events
//
//  Created by Md.Ballal Hossen on 17/7/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import MapKit

public class EventDetailsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var gaustCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
//        GMSServices.provideAPIKey("AIzaSyDi1m4yRmI2hyzxZ5Bl7HwJ-uLmVo4tNM0")
        
        gaustCollectionView.delegate = self
        gaustCollectionView.dataSource = self
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        

        // 1
        let location = CLLocationCoordinate2D(latitude: 51.50007773,
                                              longitude: -0.1246402)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)

    }
 
    

    
    @IBAction func readMoreButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            print("selected")
            detailLabel.numberOfLines = 0
            
            
        }else{
            
            detailLabel.numberOfLines = 2
           
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension EventDetailsViewController {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "gaustCell", for: indexPath)
        
        // Configure the cell
        return cell

    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 50,height: 50)
    }

}
