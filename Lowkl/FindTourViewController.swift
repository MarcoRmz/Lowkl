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
import FirebaseAuth

class FindTourViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var addLocationButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    var toursFireRef: FIRDatabaseReference!
    var usersFireRef: FIRDatabaseReference!
    
    var guide: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileButton.layer.cornerRadius = self.profileButton.frame.size.width / 2
        self.profileButton.clipsToBounds = true
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.Follow // map moves depending on location
        
        geoFireRef = FIRDatabase.database().reference().child("locations")
        toursFireRef = FIRDatabase.database().reference().child("tours")
        usersFireRef = FIRDatabase.database().reference().child("users")
        geofire = GeoFire(firebaseRef: geoFireRef)
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            usersFireRef.child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                self.guide = snapshot.value!["guide"] as! Bool
                //Change guide button text depending if user is guide ot not
                if (self.guide!) {
                    print("User is guide")
                    self.addLocationButton.hidden = false
                } else {
                    print("User isn't a guide")
                    self.addLocationButton.hidden = true
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            // No user is signed in.
        }
        
        
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
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
//            annotationView?.image = UIImage(named: "addImg")
            
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
            
        var toursarray = [String]()
            self.toursFireRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                print(snapshot)
                print("ok")
                
                let tours = snapshot.children
                print(tours)
                
                for child in snapshot.children {
                    let whatever = child.value["name"] as! String
                    toursarray.append(whatever)
                }
                print(toursarray)
                if let key = key, let location = location {
                    let annotation = TourAnnotation(coordinate: location.coordinate, tourNumber: Int(key)!, locationArray: toursarray)
                    self.mapView.addAnnotation(annotation)
                }
                // ...
            }) { (error) in
                print("-----")
                print(error.localizedDescription)
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
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("NewLocation")
        
        self.presentViewController(homeViewController, animated: true, completion: nil)
        
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(view.annotation!.title!!)
        InternalHelper.sharedInstance.tourName = view.annotation!.title!!
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        toursFireRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print(snapshot.children.allObjects)
            //Change guide button text
            
            for children in snapshot.children {
                print(children.value["name"]?!)
                print(children)
                print(children.value["description"]?!)
                if children.value["name"]?!.description == InternalHelper.sharedInstance.tourName {
                    InternalHelper.sharedInstance.tourDescription = (children.value["description"]!!.description)!
                }
            }
            InternalHelper.sharedInstance.coordinate = (view.annotation?.coordinate)!
            InternalHelper.sharedInstance.tourName = view.annotation!.title!!
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeViewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("DetailView")
            
            self.presentViewController(homeViewController, animated: true, completion: nil)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
