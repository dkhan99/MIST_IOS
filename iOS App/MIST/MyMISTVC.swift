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
    @IBOutlet weak var guestSTring: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var MyTeam: UILabel!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mistIDLabel: UILabel!
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
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
            let user = (UserDefaults.standard.value(forKey: "user") as! NSDictionary)
            self.nameLabel.text = user.value(forKey: "name") as? String
            self.mistIDLabel.text = user.value(forKey: "mistId") as? String
            if let type = (user.value(forKey: "userType") as? String) {
                self.segment.isHidden = (type == "coach")
            }
            var number = "\(user.value(forKey: "phoneNumber") as! Int)"
            number.insert("-", at: number.index(number.startIndex, offsetBy: 6))
            number.insert("-", at: number.index(number.startIndex, offsetBy: 3))
            self.mobileLabel.text = "\(number)"
            self.teamLabel.text = user.value(forKey: "team") as? String
            guestSTring.isHidden = true
            logo.isHidden = true
            self.title = "My MIST"
            
            if let team = (UserDefaults.standard.value(forKey: "user") as! [String:Any])["team"] {
                FIRMessaging.messaging().subscribe(toTopic: "/topics/\(team)")
            }
            if (self.teammembers[1].isEmpty) {
                setupTeam()
            }
            
        } else { // GUEST
            for v in self.view.subviews {
                v.isHidden = true
            }
            self.title = "MIST"
            guestSTring.isHidden = false
            logo.isHidden = false
            
        }
        self.tabBarController?.tabBar.isTranslucent = false
        var count = 0
        if UserDefaults.standard.value(forKey: "notifications") != nil {
            for notification:NSDictionary in UserDefaults.standard.value(forKey: "notifications") as! [NSDictionary] {
                if notification.value(forKey: "read") as! Bool == false {
                    count+=1
                }
            }
        }
        if let root = (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController) {
            if count>0 {
                root.tabBar.items?[4].badgeValue = "\(count)"
            } else {
                root.tabBar.items?[4].badgeValue = nil
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = count
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let competitions = snapshot.value as! [String:Any]
            UserDefaults.standard.set(competitions, forKey: "competitions")
        })
        // Fill in information
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setupTeam() {
        var teamObject:NSDictionary = [:]
        let user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
        if (UserDefaults.standard.value(forKey: "team") == nil) {
            print("Team object is nil")
            self.ref.child("team").child((user.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                teamObject = snapshot.value as! NSDictionary
                UserDefaults.standard.set(teamObject, forKey: "team")
            })
        } else {
            print("Team object exists")
            teamObject = UserDefaults.standard.value(forKey: "team") as! NSDictionary
        }
        let keyList:[String] = teamObject.allKeys as! [String]
        for key in keyList {
            
            if (((teamObject.value(forKey: key) as! NSDictionary).value(forKey: "isCompetitor") as! Int) == 1) { // competitor
                self.teammembers[1].append(teamObject.value(forKey: key) as! NSDictionary)
            } else { //Coach
                self.teammembers[0].append(teamObject.value(forKey: key) as! NSDictionary)
            }
        }
        print("Team members count is \(self.teammembers[1].count)")
        if (self.teammembers.count > 0) {
            self.teammembers[0].sort(by: {($0.value(forKey: "name") as! String) < ($1.value(forKey: "name") as! String)})
            self.teammembers[1].sort(by: {($0.value(forKey: "name") as! String) < ($1.value(forKey: "name") as! String)})
            self.myTable.reloadData()
        }
        print("Reload data for table")

        self.myTable.reloadData()
    }
    override func viewDidLayoutSubviews() {
        if (UserDefaults.standard.bool(forKey: "isGuest")) {
            self.signOutButton.title  = "Sign In"
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
            return "Competitors"
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
        return teammembers.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teammembers[section].count
    }
    
    @IBAction func signout(_ sender: UIBarButtonItem) {
        if (FIRAuth.auth()?.currentUser != nil) {
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
                print("signed out")
            } catch {
                NSLog("Couldn't sign out")
            }
        }
        self.performSegue(withIdentifier: "backToRole", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToMIST(unwindSegue: UIStoryboardSegue) {
        
    }
}

