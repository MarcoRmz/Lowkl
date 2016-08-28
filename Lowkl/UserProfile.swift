//
//  UserProfile.swift
//  Lowkl
//
//  Created by Alejandro Sanchez on 8/27/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit


class UserProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    
    @IBOutlet var tableViewTaken: UITableView!
    @IBOutlet var tableViewGiven: UITableView!
    @IBOutlet weak var guideButton: UIButton!
    
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
    
    var taken = [String]()
    var given = [String]()
    
    var guide: Bool?
    var userID: String!
    
    var userDatabaseRef: FIRDatabaseReference!
    var toursDatabaseRef: FIRDatabaseReference!
    
    @IBAction func didTapGuideButton(sender: AnyObject) {
        //Check if user is guide or not
        if (!self.guide!) {
            self.userDatabaseRef.child(self.userID + "/guide").setValue(true)
            guide = true
        }
        
        //Send user to manage tours screen
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController: UIViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ManageToursStory")
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDatabaseRef = FIRDatabase.database().reference().child("users")
        toursDatabaseRef = FIRDatabase.database().reference().child("tours")
        
        self.imageUser.layer.cornerRadius = self.imageUser.frame.size.width / 2
        self.imageUser.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // Reference to Firebase storage
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://lowkl-1472333588771.appspot.com")
            let profilePictureRef = storageRef.child(user.uid+"/profilePicture.jpg")
            
            // User is signed in.
            let name = user.displayName
            let email = user.email
            self.userID = user.uid
            
            self.nameUser.text = name
            self.emailUser.text = email
            
            self.tableViewTaken.delegate = self
            self.tableViewTaken.dataSource = self
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePictureRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print("Unable to download image")
                } else {
                    if (data != nil) {
                        self.imageUser.image = UIImage(data: data!)
                    }
                }
            }
            
            if (self.imageUser.image == nil) {
                var profilePicture = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":"300", "width":"300","redirect":false], HTTPMethod: "GET")
                profilePicture!.startWithCompletionHandler({(connection, result, error) -> Void in
                    // Handle the result
                    if (error == nil) {
                        let dictionary = result as? NSDictionary
                        let data = dictionary?.objectForKey("data")
                        
                        let photoUrl = (data?.objectForKey("url"))! as! String
                        if let imageData = NSData(contentsOfURL: NSURL(string: photoUrl)!) {
                            let uploadTask = profilePictureRef.putData(imageData, metadata: nil) {
                                metadata,error in
                                if (error == nil) {
                                    let downloadUrl = metadata!.downloadURL
                                } else {
                                    print("Error downloading image")
                                }
                            }
                            self.imageUser.image = UIImage(data: imageData)
                        }
                    }
                })
            }

            // Get guide value
            userDatabaseRef.child(self.userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                self.guide = snapshot.value!["guide"] as! Bool
                //Change guide button text depending if user is guide ot not
                if (self.guide!) {
                    print("User is guide")
                    self.guideButton.setTitle("Manage Tours", forState: UIControlState.Normal)
                } else {
                    print("User isn't a guide")
                    self.guideButton.setTitle("Become a Guide", forState: UIControlState.Normal)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
            // Get Taken tours
            self.userDatabaseRef.child(self.userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let takenToursIndex = snapshot.value!["takenTours"] as! NSArray
                var tourName: String!
                
                if (takenToursIndex.count > 0) {
                    for index in takenToursIndex {
                        var intIndex = index as! NSNumber
                        self.toursDatabaseRef.child(intIndex.stringValue).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            tourName = snapshot.value!["name"] as! String
                            sleep(1)
                            self.taken.append(tourName)
                            self.tableViewTaken.reloadData()
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    print("User hasn't taken tours")
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            // No user is signed in.
        }
        
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
