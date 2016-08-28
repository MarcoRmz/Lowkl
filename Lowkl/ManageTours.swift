//
//  ManageTours.swift
//  Lowkl
//
//  Created by Alejandro Sanchez on 8/28/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Firebase

class ManageTours: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var guideDatabaseRef: FIRDatabaseReference!
    var toursDatabaseRef: FIRDatabaseReference!
    
    var owned = [String]()
    var data = ["One", "Two", "Three"]
    
    @IBOutlet var manageTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manageTable.delegate = self
        self.manageTable.dataSource = self
        
        if let user = FIRAuth.auth()?.currentUser {
            guideDatabaseRef = FIRDatabase.database().reference().child("guides")
            toursDatabaseRef = FIRDatabase.database().reference().child("tours")
            
            guideDatabaseRef.child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let ownedToursIndex = snapshot.value!["ownedTours"] as! NSArray
                var tourName: String!
                
                if (ownedToursIndex.count > 0) {
                    for index in ownedToursIndex {
                        var intIndex = index as! NSNumber
                        self.toursDatabaseRef.child(intIndex.stringValue).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            tourName = snapshot.value!["name"] as! String
                            NSThread.sleepForTimeInterval(0.05)
                            self.owned.append(tourName)
                            self.manageTable.reloadData()
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
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(owned.isEmpty){
            return 0
        }else{
            return owned.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "CellManage"
        var cell = self.manageTable.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        cell.textLabel!.text = owned[indexPath.row]
        
        //configure right buttons
        cell.rightButtons =
            [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
                self.self.owned.removeAtIndex(indexPath.row)
                self.manageTable.reloadData()
            return true
            })
            , MGSwipeButton(title: "Edit", backgroundColor: UIColor.grayColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("EditView") as UIViewController;
                self.presentViewController(vc, animated: true, completion: nil);
                return true
            })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        
        return cell
    }
    
    
    
}
