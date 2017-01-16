//
//  SelectRoleVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/26/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class SelectRoleVC: UIViewController {
    var ref:FIRDatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        print("current user \(FIRAuth.auth()?.currentUser)")
        if let user = FIRAuth.auth()?.currentUser {
            print("user uid is \(user.uid)")
            self.ref?.child("registered-user").child(user.uid).observe(.value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                print("already logged in")
                self.ref?.child("team").child((value.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                    let teamObject = snapshot.value as! NSDictionary
                    UserDefaults.standard.set(teamObject, forKey: "team")
                    self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
                    
                })
            })
        } else {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            print("not logged in")
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func guestSelected(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isGuest")
    }
    @IBAction func studentSelected(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isGuest")
    }
    @IBAction func coachSelected(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isGuest")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "coach") {
            if let DestVC = segue.destination as? RegisterVC {
                DestVC.role = "Coach"
            }
        } else if (segue.identifier == "isGuest") {
            UserDefaults.standard.set(true, forKey: "isGuest")
        }
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
