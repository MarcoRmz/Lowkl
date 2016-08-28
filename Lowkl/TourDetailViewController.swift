//
//  TourDetailViewController.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 27/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TourDetailViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var tourNameLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var tourGuyNameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tourNameLabel.text = InternalHelper.sharedInstance.tourName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
