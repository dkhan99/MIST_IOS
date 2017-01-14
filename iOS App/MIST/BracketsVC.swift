//
//  BracketsVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/5/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BracketsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var bracketsButton: UIButton!
    var ref:FIRDatabaseReference!
//    var selectedString:String? = ""
    var competitions:NSDictionary? = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        rulesButton.layer.cornerRadius = 15.0
        rulesButton.layer.masksToBounds = true
        bracketsButton.layer.cornerRadius = 15.0
        bracketsButton.layer.masksToBounds = true
        self.ref = FIRDatabase.database().reference()
        
        // Read competitions from database
        self.ref.child("competitions").observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                print(value)
                self.competitions = value
            } else {
                print("value is nil")
            }
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.competitions!.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedString = competitions[row]
//    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (self.competitions != nil) {
            return (self.competitions?.allKeys[row] as! String)
        } else {
            return "no data"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "rules") {
            if let DestVC = segue.destination as? BracketDetailVC {
                if (self.competitions != nil && (myPicker.numberOfRows(inComponent: 0) > 0)) {
                    DestVC.titleString = self.competitions?.allKeys[myPicker.selectedRow(inComponent: 0)] as? String
                } else {
                    DestVC.titleString = "No Data"
                }
            }
        } else if (segue.identifier == "brackets") {
            if let DestVC = segue.destination as? BracketDetailVC {
                if (self.competitions != nil && (myPicker.numberOfRows(inComponent: 0) > 0)) {
                    DestVC.titleString = self.competitions?.allKeys[myPicker.selectedRow(inComponent: 0)] as? String
                } else {
                    DestVC.titleString = "No Data"
                }
            }
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
