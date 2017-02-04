//
//  SearchViewController.swift
//  amazon
//
//  Created by Mac on 16.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var searchIndexPicker: UIPickerView!
    
    var selectItems = ["Titel", "Schlagwort"] //leider klappt isbn nicht, da ich nicht herausgefunden habe, wie man den tag in der url setzt
    var searchIndexItems = ["Books", "DVD", "Music"] //habe ich hinzugefügt, um die app ein wenig zu erweitern
    var selectedRow = Int()
    var selectedSearchIndex = Int()
    
    override func viewDidLoad() {
        viewPicker.dataSource = self
        viewPicker.delegate = self
        searchIndexPicker.delegate = self
        searchIndexPicker.dataSource = self
        textField.delegate = self
        super.viewDidLoad()
        let favoriteButton = UIBarButtonItem(title: "Favorites", style: .Plain, target: self, action: "showFavorites")
        self.navigationItem.rightBarButtonItem = favoriteButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchIdentifier" {
            if let destination = segue.destinationViewController as? TableViewController{
                destination.testText = textField.text!
                destination.searchIndex = selectedRow
                destination.searchIndexString = searchIndexItems[selectedSearchIndex]
            }
        }
        if segue.identifier == "favoritesIdentifier" {
            if let _ = segue.destinationViewController as? FavoritesTableViewController{
                
            }
        }
        
        if segue.identifier == "agbIdentifier" {
            if let description = segue.destinationViewController as? AGBViewController {
                description.AGBorImpressum = sender as! Int
            }
        }
        
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        if pickerView == searchIndexPicker {
            label.text = searchIndexItems[row]
        }else {
            label.text = selectItems[row]
        }
        label.font = UIFont(name: "System", size: 14)
        label.textAlignment = .Center
        return label
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == searchIndexPicker {
         return searchIndexItems.count
        } else {
        return selectItems.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == searchIndexPicker {
            selectedSearchIndex = row
        }else{
            selectedRow = row
        }
    }
    
    
    
    @IBAction func searchAction(sender: AnyObject) {
        //print(textField.text)
        self.performSegueWithIdentifier("searchIdentifier", sender: self)
    }
    
    @IBAction func agbAction(sender: AnyObject) {
        let agb = 1
        self.performSegueWithIdentifier("agbIdentifier", sender: agb)
    }
    
    
    @IBAction func impressumAction(sender: AnyObject) {
        let impressum = 2
        self.performSegueWithIdentifier("agbIdentifier", sender: impressum)
    }
    
    
    func showFavorites(){
        self.performSegueWithIdentifier("favoritesIdentifier", sender: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //textField.resignFirstResponder()
    }
    
}

