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
    
    let pickerData = ["Monterrey", "San Luis", "Cancun"]
    let placesMonterrey = ["Cola de caballo", "Tec de Monterrey", "Fiji"]
    let placesSanLuis = ["Damn", "Come", "On"]
    let placesCancun = ["Palatzo", "Canc", "D"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerPlace.dataSource = self
        self.pickerPlace.delegate = self
        
        self.tablePlaces.dataSource = self
        self.tablePlaces.delegate = self
        
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
        tablePlaces.reloadData()
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTours", forIndexPath: indexPath)
        if(placeChosen.text! == "Monterrey"){
            let m = placesMonterrey[indexPath.row]
            cell.textLabel?.text = m
            return cell
        }else if(placeChosen.text! == "San Luis"){
            let s = placesSanLuis[indexPath.row]
            cell.textLabel?.text = s
            return cell
        }else if(placeChosen.text! == "Cancun"){
            let c = placesCancun[indexPath.row]
            cell.textLabel?.text = c
            return cell
        }
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(placeChosen.text == "Monterrey"){
            if(placesMonterrey.isEmpty){
                return 0
            }else{
                return placesMonterrey.count
            }
        }else if(placeChosen.text == "San Luis"){
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
    
}

