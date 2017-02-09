//
//  LoginScreenVCViewController.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/26/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import FirebaseInstanceID
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging

class LoginScreenVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.emailField.autocorrectionType = .no
        // Do any additional setup after loading the view.
        if (FIRAuth.auth()?.currentUser) != nil {
            // Segue to next screen
            self.performSegue(withIdentifier: "passLogin", sender: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    @IBAction func unwindLogin(segue: UIStoryboardSegue) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == passField {
            self.view.frame = CGRect(x: 0, y: -85, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        return true
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if (emailField.text != nil) && (passField.text != nil) {
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
            
                if let error = error {
                    //print(error.localizedDescription)
                    //self.errorLabel.text = error.localizedDescription
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        self.passField.text = ""
                        self.emailField.text = ""
                        self.emailField.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                if user != nil {
                    if (UserDefaults.standard.value(forKey: "user") != nil) {
                        let appDomain = Bundle.main.bundleIdentifier
                        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                    }
                    // Segue to next screen
                    self.errorLabel.text=""
                    self.ref.child("registered-user").child(user!.uid).observe(.value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        if (value?.value(forKey: "userType") as? String == "competitor") {
                            FIRMessaging.messaging().subscribe(toTopic: "/topics/competitor")
                        } else {
                            FIRMessaging.messaging().subscribe(toTopic: "/topics/coach")
                        }
                        UserDefaults.standard.set(value, forKey: "user")
                        self.ref.child("team").child((value!.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                            let teamObject = snapshot.value as! NSDictionary
                            UserDefaults.standard.set(teamObject, forKey: "team")
                            self.performSegue(withIdentifier: "passLogin", sender: nil)
                        })

                    })
                    
                    if let refreshedToken = FIRInstanceID.instanceID().token() {
                        self.ref.child("registered-user/\(user!.uid)/token").setValue(refreshedToken)
                        
                    }
                    
                    UserDefaults.standard.set(false, forKey: "isGuest")
                    
                    
                }
            })
            
            
        } else {
            self.errorLabel.text = "Please enter your email and mobile number to continue."
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
