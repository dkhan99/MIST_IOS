//
//  BracketsVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/5/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SafariServices

class BracketsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var bracketsButton: UIButton!
    var ref:FIRDatabaseReference!
//    var selectedString:String? = ""
    var competitions:NSDictionary? = [:]
    var compNames:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        rulesButton.layer.cornerRadius = 15.0
        rulesButton.layer.masksToBounds = true
        bracketsButton.layer.cornerRadius = 15.0
        bracketsButton.layer.masksToBounds = true
        self.ref = FIRDatabase.database().reference()
        competitions = (UserDefaults.standard.value(forKey: "competitions") as? NSDictionary)
        compNames = ((UserDefaults.standard.value(forKey: "competitions") as? NSDictionary)?.allKeys as! [String]).sorted()
        // Read competitions from database
        
        
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
    
    @IBAction func viewRules(_ sender: UIButton) {
//        if let url = URL(string: "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/5869929b20099ecdf7a0dc22/1483313820637/Culinary+Arts+Ballot+pdf.pdf") {
//            UIApplication.shared.open(url)
//        }
        let svc = SFSafariViewController(url: URL(string: "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/5869929b20099ecdf7a0dc22/1483313820637/Culinary+Arts+Ballot+pdf.pdf")!)
        self.present(svc,animated:true, completion:nil)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.compNames.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ((competitions?[compNames[row]] as? NSDictionary)?["isBracket"] as? Bool != true) {
            bracketsButton.isHidden = true;
        } else {
            bracketsButton.isHidden = false;
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (self.compNames.count != 0) {
            return (self.compNames[row])
        } else {
            return "no data"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "rules") {
            if let DestVC = segue.destination as? BracketDetailVC {
                if (compNames.count > 0 && (myPicker.numberOfRows(inComponent: 0) > 0)) {
                    DestVC.titleString = self.compNames[myPicker.selectedRow(inComponent: 0)]
                } else {
                    DestVC.titleString = "No Data"
                }
            }
        } else if (segue.identifier == "brackets") {
            if let DestVC = segue.destination as? BracketDetailVC {
                if ((compNames.count > 0) && (myPicker.numberOfRows(inComponent: 0) > 0)) {
                    DestVC.titleString = self.compNames[myPicker.selectedRow(inComponent: 0)]
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
