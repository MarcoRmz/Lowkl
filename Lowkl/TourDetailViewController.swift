//
//  TourDetailViewController.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 27/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TourDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var tourNameLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var tourGuyNameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tourNameLabel.text = InternalHelper.sharedInstance.tourName

        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.Follow // map moves depending on location
        centerMapOnLocation(InternalHelper.sharedInstance.coordinate)
        
        self.descriptionTextView.text = "Lorem ipsum"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 900, 900)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    

}
