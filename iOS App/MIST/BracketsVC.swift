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
    let ref:FIRDatabaseReference = FIRDatabase.database().reference(withPath: "competition")
    let resultref:FIRDatabaseReference = FIRDatabase.database().reference(withPath: "competition_test")
    var competitions:[String:Any] = [:]
    var compNames:[String] = []
    var compResults:[String:Any] = [:]
    var resultArray:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        rulesButton.layer.cornerRadius = 15.0
        rulesButton.layer.masksToBounds = true
        bracketsButton.layer.cornerRadius = 15.0
        bracketsButton.layer.masksToBounds = true
        if let competitions = UserDefaults.standard.value(forKey: "competitions") as? [String : Any] {
            self.competitions = competitions
        }
        resultref.observeSingleEvent(of: .value, with: { snapshot in
            self.compResults = snapshot.value as! [String:Any]
        })
        if (self.competitions.count > 0) {
            self.compNames = self.competitions.keys.sorted()
        }
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.competitions = snapshot.value as! [String:Any]
            if (self.competitions.count > 0) {
                self.compNames = self.competitions.keys.sorted()
                self.myPicker.reloadAllComponents()
                self.myPicker.selectRow(13, inComponent: 0, animated: true)
                self.pickerView(self.myPicker, didSelectRow: 13, inComponent: 0)
                self.bracketsButton.isEnabled = true;
                self.bracketsButton.alpha = 1.0
                UserDefaults.standard.set(self.competitions, forKey: "competitions")
            }
            
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!competitions.isEmpty) {
            if let indx = self.myPicker?.selectedRow(inComponent: 0) {
                if ((competitions[compNames[indx]] as? NSDictionary)?["isBracket"] as? Bool == true) {
                    bracketsButton.isEnabled = true
                    bracketsButton.alpha = 1.0
                } else {
                    bracketsButton.isEnabled = false
                    bracketsButton.alpha = 0.4
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewBracket(_ sender: UIButton) {
        let compName = self.compNames[myPicker.selectedRow(inComponent: 0)]
        self.resultArray = (self.compResults[compName] as! [String:Any])["results"] as! [[String:Any]]
        self.performSegue(withIdentifier: "brackets", sender: nil)
    }
    @IBAction func viewRules(_ sender: UIButton) {
//        if let url = URL(string: "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/5869929b20099ecdf7a0dc22/1483313820637/Culinary+Arts+Ballot+pdf.pdf") {
//            UIApplication.shared.open(url)
//        }
        let url = (competitions[compNames[self.myPicker.selectedRow(inComponent: 0)]] as! [String:Any])["url"] as! String
        let svc = SFSafariViewController(url: URL(string: url)!)
        self.present(svc,animated:true, completion:nil)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.compNames.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ((competitions[compNames[row]] as? NSDictionary)?["isBracket"] as? Bool == true) {
            bracketsButton.isEnabled = true
            bracketsButton.alpha = 1.0
        } else {
            bracketsButton.isEnabled = false;
            bracketsButton.alpha = 0.4
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.bracketsButton.isEnabled = false
        self.bracketsButton.alpha = 0.4
        if (self.compNames.count != 0) {
            return (self.compNames[row])
        } else {
            return "no data"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "brackets") {
            if let DestVC = segue.destination as? BracketDetailVC {
                if ((compNames.count > 0) && (myPicker.numberOfRows(inComponent: 0) > 0)) {
                    DestVC.titleString = self.compNames[myPicker.selectedRow(inComponent: 0)]
                    DestVC.resultArray = self.resultArray
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
