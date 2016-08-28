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
    
    var mapHasCenteredOnce = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.Follow // map moves depending on location
        
        toursFireRef = FIRDatabase.database().reference().child("tours")
        geoFireRef = FIRDatabase.database().reference().child("locations")
        geofire = GeoFire(firebaseRef: geoFireRef)
        
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
        var count: Int = 0
        self.toursFireRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            print(snapshot)
            print("ok")
            
            let tours = snapshot.children
            print(tours)
            
            for child in snapshot.children {
                count = count + 1
            }
            print(count)
            // ...
            self.createSighting(forLocation: loc, withId: count, titleName: self.nameTextField.text!, description: self.descriptionTextField.text!)
        }) { (error) in
            print("-----")
            print(error.localizedDescription)
        }

        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createSighting(forLocation location: CLLocation, withId tourId: Int, titleName: String, description: String) {
        //geofire.setLocation(location, forKey: "\(tourId)")
        print("create sighting")
        geofire.setLocation(location, forKey: "\(tourId)", withCompletionBlock:  { (error) in
            if error != nil {
                print("error")
            } else {
                print("Se guarda esto")
                self.toursFireRef.child("\(tourId)").child("name").setValue("\(titleName)")
                self.toursFireRef.child("\(tourId)").child("description").setValue("\(description)")
            }
        })
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location)
                mapHasCenteredOnce = true
            }
        }
    }

}
