//
//  ProgramVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 3/1/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class ProgramVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var day = "FRIDAY"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = day
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
        if let pdf = Bundle.main.url(forResource: day, withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
