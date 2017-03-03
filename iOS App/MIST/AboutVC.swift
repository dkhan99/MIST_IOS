//
//  AboutVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 2/27/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var aboutView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "0.2.2"
        aboutView.text = "Copyright © MIST Atlanta 2017\n\nDeveloper: Muhammad Doukmak\nVersion: \(version) Released March 3, 2017"
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
            url = "https://www.mistatlanta.com/legal/eula"
        case "Privacy Policy" :
            url = "https://www.mistatlanta.com/legal/privacy"
        case "Licenses" :
            url = "https://www.mistatlanta.com/legal/licenses"
        default:
            url = "https://www.mistatlanta.com"
        }
        UIApplication.shared.open(NSURL(string:url) as! URL, options: [:], completionHandler: nil)
    }
}
