//
//  AboutVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 2/27/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickLink(_ sender: UIButton) {
        let url = "http://www.mistatlanta.com"
        UIApplication.shared.open(NSURL(string:url) as! URL, options: [:], completionHandler: nil)
    }
}
