//
//  UserProfile.swift
//  Lowkl
//
//  Created by Alejandro Sanchez on 8/27/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit

class UserProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var nameUser: UILabel!
    
    @IBOutlet var tableViewTaken: UITableView!
    @IBOutlet var tableViewGiven: UITableView!
    
    @IBAction func didTapLogoutButton(sender: AnyObject) {
        //Signs user out of FireBase
        try! FIRAuth.auth()!.signOut()
        
        //Sign user out of Facebook
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        //Send user back to home screen
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    var  taken = [String]()
    var  given = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTaken.delegate = self
        self.tableViewTaken.dataSource = self
        
        taken = ["Bahamas", "Kualalupur", "Fiji"]
        given = ["Monterrey","Cancun"]
        
        self.tableViewGiven.delegate = self
        self.tableViewGiven.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(tableView.isEqual(tableViewTaken)){
            let cell = tableView.dequeueReusableCellWithIdentifier("CellToursTaken", forIndexPath: indexPath)
            let take = taken[indexPath.row]
            cell.textLabel?.text = take
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CellToursGiven", forIndexPath: indexPath)
            let give = given[indexPath.row]
            cell.textLabel?.text = give
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.isEqual(tableViewTaken)){
            return taken.count
        }else{
            return given.count
        }
        
    }
    
    
    
}
