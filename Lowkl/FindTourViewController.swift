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
    
    @IBOutlet weak var profileButton: UIButton!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    var toursFireRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileButton.layer.cornerRadius = self.profileButton.frame.size.width / 2.5
        self.profileButton.clipsToBounds = true
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.Follow // map moves depending on location
        
        geoFireRef = FIRDatabase.database().reference().child("locations")
        toursFireRef = FIRDatabase.database().reference().child("tours")
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
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
        let annoIdentifier = "Tour"
        var annotationView: MKAnnotationView?
        
        if annotation.isKindOfClass(MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            //annotationView?.image = UIImage(named: "")
        } else if let deqAnno = mapView.dequeueReusableAnnotationViewWithIdentifier(annoIdentifier) {
            annotationView = deqAnno
            
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? TourAnnotation {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "locationPin")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "location-map-flat"), forState: .Normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    // save locations on firebase
    func createSighting(forLocation location: CLLocation, withId tourId: Int, titleName: String) {
        //geofire.setLocation(location, forKey: "\(tourId)")
        
        geofire.setLocation(location, forKey: "\(tourId)", withCompletionBlock:  { (error) in
            if error != nil {
                print("error")
            } else {
                self.toursFireRef.child("\(tourId)").child("name").setValue("\(titleName)")
            }
        })
    }
    
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geofire.queryAtLocation(location, withRadius: 2.5)
        _ = circleQuery?.observeEventType(.KeyEntered, withBlock: { (key, location) in
            
            if let key = key, let location = location {
                let annotation = TourAnnotation(coordinate: location.coordinate, tourNumber: Int(key)!)
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(loc)
    }
    
    @IBAction func addRandomPlace(sender: AnyObject) {
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let rand = arc4random_uniform(4) + 1
        let randomNames = ["Paseo Tec", "Cintermex", "Tec", "Fundidora"]
        print(rand)
        createSighting(forLocation: loc, withId: Int(rand), titleName: randomNames[Int(rand)-1])
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("this shit works!")
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("DetailView")
        
        self.presentViewController(homeViewController, animated: true, completion: nil)
        
    }

}
