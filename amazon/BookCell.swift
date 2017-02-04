//
//  BookCell.swift
//  amazon
//
//  Created by Mac on 18.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import Foundation
import UIKit

class BookCell: UITableViewCell
{
    @IBOutlet weak var bookTitle : UILabel!
    @IBOutlet weak var author : UILabel!
    @IBOutlet weak var publisher : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var pictureView : UIImageView!
    
    /*
    override func awakeFromNib() {
        self.bookTitle.textColor = UIColor(red: 1.0  , green: 1.0, blue: 1.0, alpha: 1.0)
    }
    */
    var item:Book?
    {
        didSet
            {
                self.bookTitle.text = self.item?.title
                self.author.text = self.item?.author
                self.publisher.text = self.item?.publisher
                self.price.text = self.item?.price
                if let url = NSURL(string: (self.item?.smallPictureURL)!) {
                    if let data = NSData(contentsOfURL: url) {
                        pictureView.image = UIImage(data: data)
                    }
                }
        }
    }
}