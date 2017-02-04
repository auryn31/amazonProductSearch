//
//  FavoritesTableViewController.swift
//  amazon
//
//  Created by Mac on 19.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    var select = Int()
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")
        //books = SaveFavorites.saveInstance.getFavorites()
    }
    
    override func viewWillAppear(animated: Bool) {
        books = SaveFavorites.saveInstance.getFavorites()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCell
        cell.item = books[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailView" {
            if let destination = segue.destinationViewController as? DetailViewController{
                destination.book = books[select]
                destination.calledWithId = 2
            }
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        select = indexPath.row
        self.performSegueWithIdentifier("detailView", sender: self)
    }
}
