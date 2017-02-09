//
//  RegisterVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/8/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterVC: UIViewController {
    var ref: FIRDatabaseReference!
    @IBOutlet weak var roleString: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var mistIDField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var role:String! = "Student"
    override func viewDidLoad() {
        super.viewDidLoad()
        roleString.text = "New \(self.role!) Account"
        // Do any additional setup after loading the view.
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    @IBAction func register(_ sender: UIButton) {
        if ((emailField.text != "") && (passField.text != "") && (mistIDField.text != "")) {
            self.ref = FIRDatabase.database().reference()
            // FIX THIS >>>>><<<<<<<>>>>>>><<<<<
            self.ref.child("registered-user").observeSingleEvent(of: .value, with:{  snapshot in
                if (!(snapshot.value as! NSDictionary).allKeys(for: self.mistIDField.text!).isEmpty) {
                    // User already exists!
                    print("User already exists")
                    let alert = UIAlertController(title: "Alert", message: "This user already exists!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        self.passField.text = ""
                        self.mistIDField.text = ""
                        self.emailField.text = ""
                        self.emailField.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else { // User does not exist
                    print("creating new user in database")
                    self.ref.child("user").child(self.mistIDField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
                        FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passField.text!) { (user, error) in
                            
                            if let error = error {
                                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                    self.passField.text = ""
                                    self.emailField.text = ""
                                    self.emailField.becomeFirstResponder()
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            if user != nil {
                                // Segue to next screen
                                if (UserDefaults.standard.value(forKey: "user") != nil) {
                                    let appDomain = Bundle.main.bundleIdentifier
                                    UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                                }
                                let value = snapshot.value as? NSDictionary
                                if (value?.value(forKey: "userType") as? String == "competitor") {
                                    FIRMessaging.messaging().subscribe(toTopic: "/topics/competitor")
                                } else {
                                    FIRMessaging.messaging().subscribe(toTopic: "/topics/coach")
                                }
                                self.ref.child("registered-user").child(user!.uid).setValue(value)
                                UserDefaults.standard.set(value, forKey: "user")
                                self.ref.child("team").child((value!.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                                    let teamObject = snapshot.value as! NSDictionary
                                    UserDefaults.standard.set(teamObject, forKey: "team")
                                })
                                self.errorLabel.text=""
                                if let refreshedToken = FIRInstanceID.instanceID().token() {
                                    self.ref.child("registered-user/\(user!.uid)/token").setValue(refreshedToken)
                                }
                                self.performSegue(withIdentifier: "success", sender: nil)
                                UserDefaults.standard.set(false, forKey: "isGuest")
                                
                            }
                        }
                    })
                }
            })
            
            
        } else {
            let alert = UIAlertController(title: "Registration Error", message: "Please complete all required fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
