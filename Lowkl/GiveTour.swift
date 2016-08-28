//
//  GiveTour.swift
//  Lowkl
//
//  Created by Alejandro Sanchez on 8/27/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import UIKit

class GiveTour: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var tablePlaces: UITableView!
    @IBOutlet var pickerPlace: UIPickerView!
    @IBOutlet var labelChoose: UILabel!
    @IBOutlet var labelChosen: UILabel!
    
    @IBOutlet var chooseLabel: UILabel!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var ChooseButton: UIButton!
    @IBOutlet var labelGoingTo: UILabel!
    
    
    @IBOutlet var chosenFinal: UILabel!
    @IBOutlet var chosenCompany: UILabel!
    
    var arrayLocations = [String]()
    
    var placeChosen = "Monterrey"
    let pickerData = ["Monterrey", "San Luis", "Cancun"]
    var placesMonterrey = ["Cola de caballo", "Tec de Monterrey", "Fiji"]
    var placesSanLuis = ["Damn", "Come", "On"]
    var placesCancun = ["Palatzo", "Canc", "D"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerPlace.dataSource = self
        self.pickerPlace.delegate = self
        
        self.tablePlaces.dataSource = self
        self.tablePlaces.delegate = self
        
        self.tablePlaces.hidden = true
        self.chooseLabel.hidden = true
        self.finishButton.hidden = true
        self.labelChosen.hidden = true
        self.chosenCompany.hidden = true
        self.chosenFinal.hidden = true
        self.labelGoingTo.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placeChosen = pickerData[row]
        print(placeChosen)
        tablePlaces.reloadData()
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTours", forIndexPath: indexPath)
        if(placeChosen == "Monterrey"){
            let m = placesMonterrey[indexPath.row]
            cell.textLabel?.text = m
            return cell
        }else if(placeChosen == "San Luis"){
            let s = placesSanLuis[indexPath.row]
            cell.textLabel?.text = s
            return cell
        }else if(placeChosen == "Cancun"){
            let c = placesCancun[indexPath.row]
            cell.textLabel?.text = c
            return cell
        }else{
            let place = "text"
            cell.textLabel?.text = place
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(placeChosen == "Monterrey"){
            arrayLocations.append(placesMonterrey[indexPath.row])
            labelChosen.text = functionUpdateLabel().componentsJoinedByString(",")
            placesMonterrey.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }else if(placeChosen == "San Luis"){
            arrayLocations.append(placesSanLuis[indexPath.row])
            labelChosen.text = functionUpdateLabel().componentsJoinedByString(",")
            placesSanLuis.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }else if(placeChosen == "Cancun"){
            arrayLocations.append(placesCancun[indexPath.row])
            labelChosen.text = functionUpdateLabel().componentsJoinedByString(",")
            placesCancun.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(placeChosen == "Monterrey"){
            if(placesMonterrey.isEmpty){
                return 0
            }else{
                return placesMonterrey.count
            }
        }else if(placeChosen == "San Luis"){
            if(placesSanLuis.isEmpty){
                return 0
            }else{
                return placesSanLuis.count
            }
            
        }else{
            if(placesCancun.isEmpty){
                return 0
            }else{
                return placesCancun.count
            }
        }
    }
    @IBAction func finishedSelection(sender: AnyObject) {
    }
    
    func functionUpdateLabel()->NSArray{
        let myArray = arrayLocations
        
        return myArray
    }
    
    
    @IBAction func cityChosen(sender: AnyObject) {
        self.labelChoose.hidden = true
        self.pickerPlace.hidden = true
        self.ChooseButton.hidden = true
        self.chosenCompany.hidden = false
        self.chosenFinal.hidden = false
        self.chooseLabel.hidden = false
        self.tablePlaces.hidden = false
        self.finishButton.hidden = false
        self.labelChosen.hidden = false
        self.labelGoingTo.hidden = false
        
        chosenFinal.text = placeChosen
        
    }
}

