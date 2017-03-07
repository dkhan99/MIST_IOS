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
    @IBOutlet weak var MISTphone: UIImageView!
    @IBOutlet weak var Policephone: UIImageView!
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
        addShadows()
        
    }
    @IBAction func callMIST(_ sender: UIButton) {
        var formatedNumber = "678-561-6478"
        var phoneUrl = "telprompt://\(formatedNumber)"
        var url:URL = URL(string: phoneUrl)!
        
        let mistUser = UserDefaults.standard.value(forKey: "user") as? [String:Any]
        let type = mistUser?["userType"] as? String
        let today = Date.init()
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat="MM/dd/yy hh:mma"
        formatter.timeZone = NSTimeZone.system
//        let todayString = "3/21/17 10:00am"
//        let today = formatter.date(from: todayString)!
        let start = "3/17/17 12:00am"
        let end = "3/20/17 12:00am"
        var inRange = false
        let startdate = formatter.date(from: start)
        let enddate = formatter.date(from: end)
        if (today > startdate! && today < enddate!) {
            inRange = true
        }
        if mistUser != nil && type != nil && type == "coach" && inRange {
            let alert = UIAlertController(title: "Contact MIST", message: "Who would you like to contact from MIST?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "MIST Help Desk", style: .default, handler: { action in
                UIApplication.shared.open(url)
            }))
            alert.addAction(UIAlertAction(title: "MIST On-Duty Nurse", style: .default, handler: { action in
                formatedNumber = "404-317-1431"
                phoneUrl = "telprompt://\(formatedNumber)"
                url = URL(string: phoneUrl)!
                UIApplication.shared.open(url)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else { // not coach
            UIApplication.shared.open(url)
        }
    }
    
    func addShadows() {
        for view in self.view.subviews {
            if let button = view as? UIButton {
                button.layer.masksToBounds = false
                button.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
                button.layer.shadowOffset = CGSize(width: 0, height: 0)
                button.layer.shadowOpacity = 0.8
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProgram" {
            if let dest = segue.destination as? ProgramVC {
                switch sender as! UIButton {
                case fridayButton:
                    dest.day = "FRIDAY"
                case saturdayButton:
                    dest.day = "SATURDAY"
                case sundayButton:
                    dest.day = "SUNDAY"
                default:
                    break;
                }
            }
        }
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
