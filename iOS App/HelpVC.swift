//
//  HelpVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/4/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit
import SafariServices

class HelpVC: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var MISTHelpButton: UIButton!
    @IBOutlet weak var CampusPoliceButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        MISTHelpButton.layer.cornerRadius = 15.0
        MISTHelpButton.layer.masksToBounds = true
        CampusPoliceButton.layer.cornerRadius = 15.0
        CampusPoliceButton.layer.masksToBounds = true
        fridayButton.layer.cornerRadius = 15.0
        saturdayButton.layer.cornerRadius = 15.0
        sundayButton.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
    @IBAction func callMIST(_ sender: UIButton) {
        let formatedNumber = "678-561-6478"
        let phoneUrl = "telprompt://\(formatedNumber)"
        let url:URL = URL(string: phoneUrl)!
        UIApplication.shared.open(url)
    }
    @IBAction func viewFriday(_ sender: UIButton) {
        let url = "http://www.getmistified.com/atlanta/wp-content/uploads/2015/03/ForPostingMIST2015OfficialDesignedProgram.pdf"
        let svc = SFSafariViewController(url: URL(string: url)!)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.present(svc,animated:true, completion:nil)
    }

    @IBAction func callCampusPolice(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Call Campus Police", message: "You should only call the police in the case of an emergency. Are you sure you want to call campus police?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { alertAction in
            let formatedNumber = "706-542-5813"
            let phoneUrl = "telprompt://\(formatedNumber)"
            let url:URL = URL(string: phoneUrl)!
            UIApplication.shared.open(url)
        })
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action2)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
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
