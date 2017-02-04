//
//  ParserXML.swift
//  amazon
//
//  Created by Mac on 18.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import Foundation

protocol XMLParserDelegate {
    func XMLParserError(parser: ParserXML, error: String)
}

class ParserXML:NSObject, NSXMLParserDelegate {
    
    var delegate: XMLParserDelegate?
    var books = [Book]()
    var count:Int = 0
    var foundPrice:Bool = false
    
    var smallImageURL:Bool = false
    var bigImageURL:Bool = false
    var handler: (()->Void)?
    var inItem: Bool = false
    
    var element = String()
    
    let url: String
    
    init(url: String) {
        self.url=url
    }
    
    /*
    //asynchoner parser Start
    func parse(handler: ()->Void)
    {
        self.handler = handler
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            let xmlCode = NSData(contentsOfFile: "./Users/auryn/Documents/ios_apps/amazon/result.xml")
            //let string = NSString(data: xmlCode!, encoding: NSASCIIStringEncoding)
            //print(string)
            
            let parser = NSXMLParser(data: xmlCode!)
            parser.delegate = self
            parser.parse()
            if !parser.parse(){
                self.delegate?.XMLParserError(self, error: "Parsen Fehlgeschlagen")
            }
        }
    }
    
    */
    
    
    
    //synchroner Parser
    func waitParser(url:NSURL){
        let xmlCodewithAnd = NSData(contentsOfURL: url)
        //let xmlCodewithAnd = NSData(contentsOfFile: "./Users/auryn/Documents/ios_apps/amazon/result.xml")
        
        
        if xmlCodewithAnd != nil{
            var xmlCodewithoutAnd = NSString (data: xmlCodewithAnd!, encoding:  NSUTF8StringEncoding)
            xmlCodewithoutAnd = xmlCodewithoutAnd!.stringByReplacingOccurrencesOfString("&", withString: "&amp;")
            let data = xmlCodewithoutAnd!.dataUsingEncoding(NSUTF8StringEncoding)
            let xmlParser = NSXMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
        }
    }
    
    
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "Item" && inItem == false){
            //object.removeAll(keepCapacity: false)
            inItem = true
            let book = Book(asin:"", author: "", eisbn: "", label: "", numberOfPages: "", publicationDate: "", publisher: "", title: "", price: "free", isbn: "", url: "", pictureUrl: "", smallPictureURL: "")
            books+=[book]
        }
        element = elementName
        
        if elementName == "LargeImage" {
            bigImageURL = true
        }
        if elementName == "SmallImage" {
            smallImageURL = true
        }
        //current = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if inItem == false || string == "\n"{
         return
        } else {
            if element == "ASIN" {
                books[count].asin = string
            }
            if element == "Author" {
                if let temp:String = books[count].author {
                    var tempString = temp
                    tempString += string
                    books[count].author = tempString
                } else {
                    books[count].author = string
                }
                books[count].author = books[count].author.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            if element == "EISBN" {
                books[count].eisbn = string
            }
            if element == "Label" {
                if let temp:String = books[count].label {
                    var tempString = temp
                    tempString += string
                    books[count].label = tempString
                } else {
                    books[count].label = string
                }
                books[count].label = books[count].label.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            if element == "NumberOfPages" {
                if let temp:String = books[count].numberOfPages {
                    var tempString = temp
                    tempString += string
                    books[count].numberOfPages = tempString
                } else {
                    books[count].numberOfPages = string
                }
                books[count].numberOfPages = books[count].numberOfPages.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            if element == "PublicationDate" {
                if let temp:String = books[count].publicationDate {
                    var tempString = temp
                    tempString += string
                    books[count].publicationDate = tempString
                } else {
                    books[count].publicationDate = string
                }
                books[count].publicationDate = books[count].publicationDate.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            if element == "Publisher" {
                if let temp:String = books[count].publisher {
                    var tempString = temp
                    tempString += string
                    books[count].publisher = tempString
                } else {
                    books[count].publisher = string
                }
                books[count].publisher = books[count].publisher.stringByReplacingOccurrencesOfString("\n", withString: "")
                
            }
            if element == "Title" {
                if let temp:String = books[count].title {
                    var tempString = temp
                    tempString += string
                    books[count].title = tempString
                } else {
                    books[count].title = string
                }
                books[count].title = books[count].title.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            if element == "ISBN" {
                if let temp:String = books[count].title {
                    var tempString = temp
                    tempString += string
                    books[count].isbn = tempString
                } else {
                    books[count].isbn = string
                }
                books[count].isbn = books[count].isbn.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            if element == "FormattedPrice" && foundPrice == false{
                books[count].price = string
                foundPrice = true
            }
            
            if element == "URL" && bigImageURL == true {
                books[count].pictureUrl = string
                books[count].pictureUrl = books[count].pictureUrl.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            
            if element == "URL" && smallImageURL == true {
                books[count].smallPictureURL = string
                books[count].smallPictureURL = books[count].smallPictureURL.stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "Item" {
                //print(books[count].pictureUrl)
                inItem = false
                foundPrice = false
                count++
        }
        if elementName == "LargeImage" {
            bigImageURL = false
        }
        if elementName == "SmallImage" {
            smallImageURL = false
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        delegate?.XMLParserError(self, error: parseError.localizedDescription)
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_main_queue()){
            if (self.handler != nil) {
                self.handler!()
            }
        }
    }
}