//
//  AGBViewController.swift
//  amazon
//
//  Created by Mac on 23.11.15.
//  Copyright © 2015 target. All rights reserved.
//

import UIKit

class AGBViewController: UIViewController {
    
    var AGBorImpressum = Int()
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoText: UITextView!
    
    let agbs = "Hier stehen die Algemeinen Geschäftsbedingungen"
    let impressum = "Auryn"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch AGBorImpressum{
        case 1:
            headerLabel.text = "AGB"
            infoText.text = agbs
        case 2:
            headerLabel.text = "Impressum"
            infoText.text = impressum
        default:
            headerLabel.text = "FAIL"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
