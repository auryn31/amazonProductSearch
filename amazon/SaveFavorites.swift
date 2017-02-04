//
//  SaveFavorites.swift
//  amazon
//
//  Created by Mac on 21.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import Foundation

class SaveFavorites {
    
    static let saveInstance = SaveFavorites()
    
    var books = [Book]()

    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL!
        return url.URLByAppendingPathComponent("saveBooks").path!
    }
    
    func addToSave(book:Book){
        books.append(book)
        var saveBooksWithoutRedundante = [Book]()
        for i in 0...(books.count-1) {
            let book = books[i]
            var isInserted:Bool = false
            if i>0 {
                for j in 0...(i-1) {
                    if book.title == books[j].title {
                        isInserted = true
                    }
                }
            }
            if isInserted == false {
                saveBooksWithoutRedundante.append(book)
            }
        }
        books = saveBooksWithoutRedundante
        saveData()
    }
    
    func deleteFromFavorites(title:String){
        var deleteID = Int()
        for i in 0...(books.count-1) {
            if title == books[i].title {
                deleteID = i
            }
        }
        books.removeAtIndex(deleteID)
        saveData()
    }
    
    func saveData (){
        NSKeyedArchiver.archiveRootObject(books, toFile: filePath)
    }
    
    func getFavorites()->[Book]{
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Book] {
            books = array
        }
        return books
    }
    
    func readData(){
        
    }
}