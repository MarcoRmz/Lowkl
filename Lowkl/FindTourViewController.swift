//
//  FindTourViewController.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 27/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class FindTourViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.Follow // map moves depending on location
        
        geoFireRef = FIRDatabase.database().reference()
        geofire = GeoFire(firebaseRef: geoFireRef)
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location)
                mapHasCenteredOnce = true
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        
        if annotation.isKindOfClass(MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            //annotationView?.image = UIImage(named: "")
        }
        
        return annotationView
    }
    
    // save locations on firebase
    func createSighting(forLocation location: CLLocation, withId locationId: String) {
        geofire.setLocation(location, forKey: locationId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
