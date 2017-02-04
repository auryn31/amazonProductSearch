//
//  Book.swift
//  amazon
//
//  Created by Mac on 18.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import Foundation

class Book: NSObject, NSCoding{
    var asin = String()
    var author = String()
    var eisbn = String()
    var label = String()
    var numberOfPages = String()
    var publicationDate = String()
    var publisher :String = "publishing company"
    var title = String()
    var price: String = "free"
    var isbn = String()
    var url = String()
    var pictureUrl = String()
    var smallPictureURL = String()
    
    init(asin: String, author:String, eisbn:String, label:String, numberOfPages:String, publicationDate:String, publisher:String, title:String, price:String, isbn:String, url:String, pictureUrl:String, smallPictureURL:String) {
        self.asin = asin
        self.author = author
        self.eisbn = eisbn
        self.label = label
        self.numberOfPages = numberOfPages
        self.publicationDate = publicationDate
        self.publisher = publisher
        self.title = title
        self.price = price
        self.isbn = isbn
        self.url = url
        self.pictureUrl = pictureUrl
        self.smallPictureURL = smallPictureURL
    }
    
    convenience required init?(coder aDecoder: NSCoder){
        guard
            let asin = aDecoder.decodeObjectForKey("asin") as? String,
            let author = aDecoder.decodeObjectForKey("author") as? String,
            let eisbn = aDecoder.decodeObjectForKey("eisbn") as? String,
            let label = aDecoder.decodeObjectForKey("label") as? String,
            let numberOfPages = aDecoder.decodeObjectForKey("numberOfPages") as? String,
            let publicationDate = aDecoder.decodeObjectForKey("publicationDate") as? String,
            let publisher = aDecoder.decodeObjectForKey("publisher") as? String,
            let title = aDecoder.decodeObjectForKey("title") as? String,
            let price = aDecoder.decodeObjectForKey("price") as? String,
            let isbn = aDecoder.decodeObjectForKey("isbn") as? String,
            let url = aDecoder.decodeObjectForKey("url") as? String,
            let pictureUrl = aDecoder.decodeObjectForKey("pictureUrl") as? String,
            let smallPictureURL = aDecoder.decodeObjectForKey("smallPictureURL") as? String
        else {
            return nil
        }
        self.init(asin: asin, author:author, eisbn:eisbn, label:label, numberOfPages:numberOfPages, publicationDate:publicationDate, publisher:publisher, title:title, price:price, isbn:isbn, url:url, pictureUrl:pictureUrl, smallPictureURL:smallPictureURL)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.asin, forKey: "asin")
        aCoder.encodeObject(self.author, forKey: "author")
        aCoder.encodeObject(self.eisbn, forKey: "eisbn")
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.numberOfPages, forKey: "numberOfPages")
        aCoder.encodeObject(self.publicationDate, forKey: "publicationDate")
        aCoder.encodeObject(self.publisher, forKey: "publisher")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.price, forKey: "price")
        aCoder.encodeObject(self.isbn, forKey: "isbn")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.pictureUrl, forKey: "pictureUrl")
        aCoder.encodeObject(self.smallPictureURL, forKey: "smallPictureURL")
        
    }
}