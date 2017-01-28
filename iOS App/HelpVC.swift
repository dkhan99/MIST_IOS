//
//  HelpVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/4/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    @IBOutlet weak var MISTHelpButton: UIButton!
    @IBOutlet weak var CampusPoliceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        MISTHelpButton.layer.cornerRadius = 15.0
        MISTHelpButton.layer.masksToBounds = true
        CampusPoliceButton.layer.cornerRadius = 15.0
        CampusPoliceButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    @IBAction func callMIST(_ sender: UIButton) {
        let formatedNumber = "123-123-1234"
        let phoneUrl = "telprompt://\(formatedNumber)"
        let url:URL = URL(string: phoneUrl)!
        UIApplication.shared.open(url)
    }

    @IBAction func callCampusPolice(_ sender: UIButton) {
        let formatedNumber = "123-123-1234"
        let phoneUrl = "telprompt://\(formatedNumber)"
        let url:URL = URL(string: phoneUrl)!
        UIApplication.shared.open(url)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
