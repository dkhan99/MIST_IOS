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
    var role:String = "Student"
    override func viewDidLoad() {
        super.viewDidLoad()
        roleString.text = "New \(UserDefaults.standard.value(forKey: "role")) Account"
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
        roleString.text = ""
        if ((emailField.text != "") && (passField.text != "") && (mistIDField.text != "")) {
            self.ref = FIRDatabase.database().reference()
            self.ref.child("user").child(mistIDField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
                FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passField.text!) { (user, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        self.errorLabel.text = error.localizedDescription
                    }
                    if user != nil {
                        // Segue to next screen
                        
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
            
        } else {
            errorLabel.text = "Please complete all fields"
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
