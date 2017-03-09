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

class RegisterVC: UIViewController, UITextFieldDelegate {
    var ref: FIRDatabaseReference!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var mistIDField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var role:String! = "Student"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.continueButton.layer.cornerRadius = self.continueButton.frame.height/2.0
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
            view.endEditing(true)
            self.ref = FIRDatabase.database().reference()
            self.continueButton.isEnabled = false
            self.continueButton.alpha = 0.3
            self.indicator.startAnimating()
            // FIX THIS >>>>><<<<<<<>>>>>>><<<<<
            self.ref.child("mist_2017_user").observe(.value, with: {snapshot in
                let users = snapshot.value as? NSDictionary
                if (!(users?.allKeys as! [String]).contains(self.mistIDField.text!)) {
                    let alert = UIAlertController(title: "Registration Error", message: "MIST-ID not found. Please check your format and try again. (e.g. 1234-1234 or 1234-12345)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        self.mistIDField.text = ""
                        self.mistIDField.becomeFirstResponder()
                    }))
                    self.continueButton.isEnabled = true
                    self.continueButton.alpha = 1.0
                    self.indicator.stopAnimating()
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.ref.child("mist_2017_registered-user").observeSingleEvent(of: .value, with:{  snapshot in
                        let val = snapshot.value as! NSDictionary
                        if (val.allKeys.contains { element in
                            return (val[element as! String] as! NSDictionary)["mistId"] as! String == self.mistIDField.text!
                        }) {
                            // User already exists!
                            let alert = UIAlertController(title: "Alert", message: "A user with this MIST ID already exists!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                self.passField.text = ""
                                self.mistIDField.text = ""
                                self.emailField.text = ""
                                self.emailField.becomeFirstResponder()
                            }))
                            self.continueButton.isEnabled = true
                            self.continueButton.alpha = 1.0
                            self.indicator.stopAnimating()
                            self.present(alert, animated: true, completion: nil)
                        } else { // User does not exist
                            self.ref.child("mist_2017_user").child(self.mistIDField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
                                let value = snapshot.value as! NSDictionary
                                FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passField.text!) { (user, error) in
                                    
                                    if let error = error {
                                        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                            self.passField.text = ""
                                            self.emailField.text = ""
                                            self.emailField.becomeFirstResponder()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        self.continueButton.isEnabled = true
                                        self.continueButton.alpha = 1.0
                                        self.indicator.stopAnimating()
                                    }
                                    if user != nil {
                                        // Segue to next screen
                                        if (UserDefaults.standard.value(forKey: "user") != nil) {
                                            let appDomain = Bundle.main.bundleIdentifier
                                            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                                        }
                                        if (value.value(forKey: "userType") as? String == "competitor") {
                                            FIRMessaging.messaging().subscribe(toTopic: "/topics/competitor")
                                        } else {
                                            FIRMessaging.messaging().subscribe(toTopic: "/topics/coach")
                                        }
                                        self.ref.child("mist_2017_registered-user").child(user!.uid).setValue(value)
                                        UserDefaults.standard.set(value, forKey: "user")
                                        
                                        self.ref.child("mist_2017_team").child((value.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                                            let teamObject = snapshot.value as! NSDictionary
                                            UserDefaults.standard.set(teamObject, forKey: "team")
                                        })
                                        self.errorLabel.text=""
                                        if let refreshedToken = FIRInstanceID.instanceID().token() {
                                            self.ref.child("mist_2017_registered-user/\(user!.uid)/token").setValue(refreshedToken)
                                        }
                                        self.continueButton.isEnabled = true
                                        self.continueButton.alpha = 1.0
                                        self.indicator.stopAnimating()
                                        self.performSegue(withIdentifier: "success", sender: nil)
                                        UserDefaults.standard.set(false, forKey: "isGuest")
                                        
                                    }
                                }
                                
                            })
                            
                        }
                    })
                }
            })
            
        } else {
            let alert = UIAlertController(title: "Registration Error", message: "Please complete all required fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.continueButton.isEnabled = true
            self.continueButton.alpha = 1.0
            self.indicator.stopAnimating()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func userAgreement(_ sender: UIButton) {
        let url = "https://www.mistatlanta.com/legal/eula"
        UIApplication.shared.open(NSURL(string:url) as! URL, options: [:], completionHandler: nil)
    }
    @IBAction func privacyPolicy(_ sender: UIButton) {
        let url = "https://www.mistatlanta.com/legal/privacy"
        UIApplication.shared.open(NSURL(string: url) as! URL, options: [:], completionHandler: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            mistIDField.becomeFirstResponder()
        } else if textField == mistIDField {
            passField.becomeFirstResponder()
        } else {
            register(continueButton)
        }
        return true
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
