//
//  DetailViewController.swift
//  amazon
//
//  Created by Mac on 19.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorView: UILabel!
    @IBOutlet weak var publisherView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var isbnView: UILabel!
    @IBOutlet weak var numberOfPagesView: UILabel!    
    @IBOutlet weak var pictureView: UIImageView!
   // @IBOutlet weak var reviewView: UIWebView!
    
    var book:Book = Book(asin:"", author: "", eisbn: "", label: "", numberOfPages: "", publicationDate: "", publisher: "publishing company", title: "", price: "free", isbn: "", url: "", pictureUrl: "", smallPictureURL: "")
    var calledWithId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.text = book.title
        authorView.text = book.author
        publisherView.text = book.publisher
        priceView.text = book.price
        isbnView.text = book.isbn
        numberOfPagesView.text = book.numberOfPages
        
        
        if let url = NSURL(string: book.pictureUrl) {
            if let data = NSData(contentsOfURL: url) {
                pictureView.image = UIImage(data: data)
            }        
        }
        switch calledWithId {
        case 1:
            let favoriteButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveToFavorites")
            self.navigationItem.rightBarButtonItem = favoriteButton
        case 2:
            let deleteFromFavorites = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteFromFavorites")
            self.navigationItem.rightBarButtonItem = deleteFromFavorites
        default:
            print("es konnte kein Button erzeugt werden")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveToFavorites(){
        SaveFavorites.saveInstance.addToSave(book)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func deleteFromFavorites(){
        SaveFavorites.saveInstance.deleteFromFavorites(book.title)
        navigationController?.popViewControllerAnimated(true)
    }

}
