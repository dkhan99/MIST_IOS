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
    @IBOutlet weak var distanceleft: NSLayoutConstraint!
    @IBOutlet weak var distancetotop: NSLayoutConstraint!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var passField: UITextField!
    var ref: FIRDatabaseReference!
    var userIsEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        ref = FIRDatabase.database().reference()
        self.emailField.autocorrectionType = .no
        // Do any additional setup after loading the view.
        if (FIRAuth.auth()?.currentUser) != nil {
            // Segue to next screen
            self.performSegue(withIdentifier: "passLogin", sender: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        distanceleft.constant = 12
        distancetotop.constant = 81
        for view in self.view.subviews {
            view.resignFirstResponder()
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        distanceleft.constant = self.view.frame.size.width/5
        distancetotop.constant = 20
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passField.becomeFirstResponder()
        } else {
            distanceleft.constant = 12
            distancetotop.constant = 81
            for view in self.view.subviews {
                view.resignFirstResponder()
            }
            loginPressed(loginButton)
        }
        return true
    }
    @IBAction func forgotPassword(_ sender: UIButton) {
        let alert = UIAlertController(title: "Forgot Your Password?", message: "Enter the email associated with your account to receive instructions on resetting your password", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Email"
        })
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
            if alert.textFields![0].text != "" {
                FIRAuth.auth()?.sendPasswordReset(withEmail: (alert.textFields?[0].text!)!, completion: { error in
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Password Reset Error", message: "\(error!.localizedDescription) - Please try again with a valid email", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                        self.present(errorAlert, animated: true)
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    @IBAction func unwindLogin(segue: UIStoryboardSegue) {
    }
    
   
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if (emailField.text != "") && (passField.text != "") {
            view.endEditing(true)
            distanceleft.constant = 12
            distancetotop.constant = 81
            self.loginButton.isEnabled = false
            self.loginButton.alpha = 0.3
            self.indicator.startAnimating()
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                
                if let error = error {
                    if error._code == FIRAuthErrorCode.errorCodeNetworkError.rawValue {
                    }
                    
                    
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        self.passField.text = ""
                        self.emailField.text = ""
                        self.emailField.becomeFirstResponder()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    self.loginButton.isEnabled = true
                    self.loginButton.alpha = 1.0
                    self.indicator.stopAnimating()
                }
                if user != nil {
                    if (UserDefaults.standard.value(forKey: "user") != nil) {
                        let appDomain = Bundle.main.bundleIdentifier
                        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                    }
                    // Segue to next screen
                   self.ref.child("mist_2017_registered-user").child(user!.uid).observe(.value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        if (value?.value(forKey: "userType") as? String == "competitor") {
                            FIRMessaging.messaging().subscribe(toTopic: "/topics/competitor")
                        } else {
                            FIRMessaging.messaging().subscribe(toTopic: "/topics/coach")
                        }
                        UserDefaults.standard.set(value, forKey: "user")
                        self.ref.child("mist_2017_team").child((value!.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                            let teamObject = snapshot.value as! NSDictionary
                            UserDefaults.standard.set(teamObject, forKey: "team")
                            self.loginButton.isEnabled = true
                            self.loginButton.alpha = 1.0
                            self.indicator.stopAnimating()
                            self.performSegue(withIdentifier: "passLogin", sender: nil)
                        })

                    })
                    
                    if let refreshedToken = FIRInstanceID.instanceID().token() {
                        self.ref.child("mist_2017_registered-user/\(user!.uid)/token").setValue(refreshedToken)
                        
                    }
                    
                    UserDefaults.standard.set(false, forKey: "isGuest")
                    
                    
                } else {
                    self.loginButton.isEnabled = true
                    self.loginButton.alpha = 1.0
                    self.indicator.stopAnimating()
                }
            })
        } else {
            let alert = UIAlertController(title: "Login Error", message: "Please enter your email and password to continue.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1.0
            self.indicator.stopAnimating()
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
