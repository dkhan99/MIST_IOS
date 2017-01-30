//
//  FirstViewController.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/26/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseMessaging

class MyMISTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mistIDLabel: UILabel!
    var ref: FIRDatabaseReference!
   //let allNames: [[String]] = [["Sameera Omar", "Mae Eldahshoury"], ["Shifa Khan", "Hasib Abdulrahmaan", "Samina Sattar", "Hasan Qadri", "Rabeea Ahmed", "Matib Ahmad"]]
    var teammembers: [[NSDictionary]] = [[],[]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        myTable.contentInset = UIEdgeInsets.zero;
        profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2;
        profilePic.clipsToBounds = true
        myTable.sectionHeaderHeight = 0
        myTable.sectionFooterHeight = 0
        if (FIRAuth.auth()?.currentUser != nil) {
            
            self.ref = FIRDatabase.database().reference()
            let user = (UserDefaults.standard.value(forKey: "user") as! NSDictionary)
            self.nameLabel.text = user.value(forKey: "name") as? String
            self.mistIDLabel.text = user.value(forKey: "mistId") as? String
            var number = "\(user.value(forKey: "phoneNumber") as! Int)"
            number.insert("-", at: number.index(number.startIndex, offsetBy: 6))
            number.insert("-", at: number.index(number.startIndex, offsetBy: 3))
            self.mobileLabel.text = "\(number)"
            self.teamLabel.text = user.value(forKey: "team") as? String
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\((UserDefaults.standard.value(forKey: "user") as! [String:Any])["team"]!)")
//            ref.child("registered-user").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//                let value = snapshot.value as? NSDictionary
//                self.nameLabel.text = value?["name"] as? String ?? ""
//                self.emailLabel.text = value?["email"] as? String ?? ""
//                if let num = value?["phoneNumber"] {
//                    self.mobileLabel.text = "\(num)"
//                } else {
//                    self.mobileLabel.text = ""
//                }
//                
//                self.teamLabel.text = value?["team"] as? String ?? ""
//            })
            
        } else { // GUEST
            myTable.isHidden = true;
            nameLabel.text = "Hello, Guest"
            teamLabel.isHidden = true
            mistIDLabel.isHidden = true
            mobileLabel.isHidden = true
            profilePic.isHidden = true
            
        }
        let team = (UserDefaults.standard.value(forKey: "team") as! NSDictionary)
        let keyList:[String] = team.allKeys as! [String]
        for key in keyList {
            if (key != (UserDefaults.standard.value(forKey: "user") as! NSDictionary).value(forKey: "mistId") as! String) {
                if (((team.value(forKey: key) as! NSDictionary).value(forKey: "isCompetitor") as! Int) == 1) { // competitor
                    teammembers[1].append(team.value(forKey: key) as! NSDictionary)
                } else { //Coach
                    teammembers[0].append(team.value(forKey: key) as! NSDictionary)
                }
            }
        }
        myTable.reloadData()
        self.tabBarController?.tabBar.isTranslucent = false
        // Fill in information
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLayoutSubviews() {
        if (UserDefaults.standard.bool(forKey: "isGuest")) {
            signOutButton.titleLabel?.text = "Sign In"
        }
    }
    
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 1) {
            self.performSegue(withIdentifier: "schedule", sender: self)
            self.segment.selectedSegmentIndex = 0
            // Send USER DATA HERE
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MISTTableViewCell
        cell.nameLabel?.text = teammembers[indexPath.section][indexPath.row].value(forKey: "name") as? String!
        var number = String(describing: teammembers[indexPath.section][indexPath.row].value(forKey: "phoneNumber")!)
        number.insert("-", at: number.index(number.startIndex, offsetBy: 6))
        number.insert("-", at: number.index(number.startIndex, offsetBy: 3))
        cell.numberLabel?.text = number
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Coaches"
        } else {
            return "Teammates"
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert:UIAlertController = UIAlertController(title: "Contact \(teammembers[indexPath.section][indexPath.row].value(forKey: "name") as! String)", message: nil, preferredStyle: .actionSheet)
        
        let action1:UIAlertAction = UIAlertAction(title: "Call \(String(describing: teammembers[indexPath.section][indexPath.row].value(forKey: "phoneNumber")!))", style: .default, handler: { alertAction in
            let formatedNumber = String(describing: self.teammembers[indexPath.section][indexPath.row].value(forKey: "phoneNumber")!).components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            let phoneUrl = "telprompt://\(formatedNumber)"
            let url:URL = URL(string: phoneUrl)!
            UIApplication.shared.open(url)
        })
        let action2:UIAlertAction = UIAlertAction(title: "Message \(String(describing: teammembers[indexPath.section][indexPath.row].value(forKey: "phoneNumber")!))", style: .default, handler: nil)
        let action3:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        self.present(alert, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//        if let teammembers = teammembers {
//            return teammembers.count
//        } else {
//            return 0
//        }
        return teammembers.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let teammembers = teammembers {
//            return teammembers[section].count
//        } else {
//            return 0
//        }
        return teammembers[section].count
    }
    @IBAction func signOut(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: "isGuest") == false) {
            let value = UserDefaults.standard.value(forKey: "user") as? NSDictionary
            if (value?.value(forKey: "userType") as? String == "competitor") {
                FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/competitor")
            } else {
                FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/coach")
            }
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\((UserDefaults.standard.value(forKey: "user") as! [String:Any])["team"]!)")
            do {
                try
                    FIRAuth.auth()?.signOut()
            } catch {
                NSLog("Couldn't sign out")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToMIST(unwindSegue: UIStoryboardSegue) {
        
    }
}

