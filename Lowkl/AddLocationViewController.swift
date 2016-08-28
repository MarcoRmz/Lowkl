//
//  AddLocationViewController.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 28/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AddLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagePin: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    var toursFireRef: FIRDatabaseReference!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        geoFireRef = FIRDatabase.database().reference().child("locations")
        geofire = GeoFire(firebaseRef: geoFireRef)
         toursFireRef = FIRDatabase.database().reference().child("tours")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addLocationButtonPressed(sender: UIButton) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let rand = arc4random_uniform(4) + 1
        createSighting(forLocation: loc, withId: Int(rand), titleName: self.nameTextField.text!, description: self.descriptionTextField.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createSighting(forLocation location: CLLocation, withId tourId: Int, titleName: String, description: String) {
        //geofire.setLocation(location, forKey: "\(tourId)")
        
        geofire.setLocation(location, forKey: "\(tourId)", withCompletionBlock:  { (error) in
            if error != nil {
                print("error")
            } else {
                self.toursFireRef.child("\(tourId)").child("name").setValue("\(titleName)")
                self.toursFireRef.child("\(tourId)").child("description").setValue("\(description)")
            }
        })
    }

}
