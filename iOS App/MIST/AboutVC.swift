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
        let url:String
        switch sender.title(for: .normal)! {
        case "Facebook" :
            url = "https://www.facebook.com/MIST.Atlanta"
        case "Twitter" :
            url = "https://twitter.com/mistatlanta"
        case "Instagram" :
            url = "https://www.instagram.com/mistatlanta/"
        case "User Agreement" :
            url = "http://www.mistatlanta.com/legal/eula"
        case "Privacy Policy" :
            url = "http://www.mistatlanta.com/legal/privacy"
        case "Licenses" :
            url = "http://www.mistatlanta.com/legal/licenses"
        default:
            url = "http://www.mistatlanta.com"
        }
        UIApplication.shared.open(NSURL(string:url) as! URL, options: [:], completionHandler: nil)
    }
}
