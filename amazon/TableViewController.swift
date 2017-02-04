 //
//  TableViewController.swift
//  amazon
//
//  Created by Mac on 16.11.15.
//  Copyright © 2015 target. All rights reserved.
//
import Foundation
import UIKit
//import Alamofire


class TableViewController: UITableViewController, XMLParserDelegate {

    var pars = ParserXML(url: "test")
    var testText:String=String()
    var select = Int()
    var searchIndex:Int = Int()
    var searchIndexString = String()
    
    let nothingFoundBook = Book(asin: "", author: "", eisbn: "", label: "", numberOfPages: "", publicationDate: "", publisher: "", title: "Nothing Found, Try Again", price: "", isbn: "", url: "", pictureUrl: "", smallPictureURL: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")

       
        //parser der synchron läuft
        pars.delegate = self
        testText = testText.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        let AWS_SECRET_KEY:String = "secret"
        let AWS_ACCESS_KEY_ID:String = "access"
        
        var urlParams = String()
        
       // print(searchIndexString)
        
        switch searchIndex{
            case 0:
                urlParams = "AWSAccessKeyId=\(AWS_ACCESS_KEY_ID)&AssociateTag=9595-5338-7407&Operation=ItemSearch&ResponseGroup=Images%2CItemAttributes%2COffers%2CReviews&SearchIndex=\(searchIndexString)&Service=AWSECommerceService&Sort=salesrank&Timestamp=\(getDate().stringByReplacingOccurrencesOfString(":", withString: "%3A"))&Title=\(testText)"
            
            case 1:
                urlParams = "AWSAccessKeyId=\(AWS_ACCESS_KEY_ID)&AssociateTag=9595-5338-7407&Keywords=\(testText)&Operation=ItemSearch&ResponseGroup=Images%2CItemAttributes%2COffers%2CReviews&SearchIndex=\(searchIndexString)&Service=AWSECommerceService&Sort=salesrank&Timestamp=\(getDate().stringByReplacingOccurrencesOfString(":", withString: "%3A"))"
            
            default:
                urlParams = "AWSAccessKeyId=\(AWS_ACCESS_KEY_ID)&AssociateTag=9595-5338-7407&Keywords=\(testText)&Operation=ItemSearch&ResponseGroup=Images%2CItemAttributes%2COffers%2CReviews&SearchIndex=\(searchIndexString)&Service=AWSECommerceService&Sort=salesrank&Timestamp=\(getDate().stringByReplacingOccurrencesOfString(":", withString: "%3A"))"
        }
        
        
        let urtToCalcSig = "GET\nwebservices.amazon.de\n/onca/xml\n\(urlParams)"
        
       
        
        let signature = urtToCalcSig.digestHMac256(AWS_SECRET_KEY)
        
        let urlToSearch = "http://webservices.amazon.de/onca/xml?\(urlParams)&Signature=\(signature)"
        
       // print(urlToSearch)
        let url = NSURL(string: urlToSearch)
        pars.waitParser(url!)
        
       
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pars.books.count != 0{
            return pars.books.count}
        else{
            return 1
        }
    }
   
    
    
        
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if pars.books.count != 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCell
            cell.item = pars.books[indexPath.row]
            return cell}
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCell
            cell.item = nothingFoundBook
            return cell
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailView" {
            if let destination = segue.destinationViewController as? DetailViewController{
                destination.book = pars.books[select]
                destination.calledWithId = 1
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if pars.books.count != 0{
            select = indexPath.row
            self.performSegueWithIdentifier("detailView", sender: self)
        }
    }
    
    func XMLParserError(parser: ParserXML, error: String) {
        print(error)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122
    }
    
    func getDate()->String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        let components: NSDateComponents = NSDateComponents()
        components.setValue(-1, forComponent: NSCalendarUnit.Hour);
        
        let expirationDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return dateFormatter.stringForObjectValue(expirationDate!)!
    }

}
