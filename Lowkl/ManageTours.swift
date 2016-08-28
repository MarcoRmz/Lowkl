//
//  ManageTours.swift
//  Lowkl
//
//  Created by Alejandro Sanchez on 8/28/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ManageTours: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var data = ["One", "Two", "Three"]
    
    @IBOutlet var manageTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manageTable.delegate = self
        self.manageTable.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(data.isEmpty){
            return 0
        }else{
            return data.count
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
        
        cell.textLabel!.text = data[indexPath.row]
        
        //configure right buttons
        cell.rightButtons =
            [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
                self.self.data.removeAtIndex(indexPath.row)
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
