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
    //Stop unduing here
    let competitionList:[String] = ["2D Islamic Art", "3D Islamic Art", "Brother's Basketball","Brother's Improv", "Business Venture", "Community Service", "Culinary Arts", "Debate", "Extemporaneous Essay", "Extemporaneous Speaking", "Fashion Design", "Graphic Design", "Knowledge Tests", "MIST Bowl", "Math Olympics", "Mobile Applications", "Nasheed and Rap", "Original Oratory", "Photography", "Poetry Literature", "Poetry Spoken Word", "Prepared Essay", "Quran Memorization", "Science Fair", "Short Fictional Story", "Short Film","Sister's Basketball","Sister's Improv", "Social Media"]
    let bracketList:[String] = ["Brother's Basketball","Brother's Improv","Debate","MIST Bowl","Math Olympics","Sister's Basketball","Sister's Improv"]
    let urlList:[String] = [
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7db9bebafb21325bd50f/1485667770165/2D+Art.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7dbfff7c501134731a67/1485667775113/3D+Art.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7dd603596e0fcbc0e989/1485667798080/Basketball.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e1e1b631b0e7cf6d19f/1485667870356/Improv.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7dda86e6c04b27522ee4/1485667802939/Business+Venture.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7ddfe6f2e152d3e246ae/1485667807443/Community+Service.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7dee579fb35be4f27176/1485667822428/Culinary+Arts.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7dffbf629abc01d8d25f/1485667840236/Debate.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e068419c2ec3fd8bd4f/1485667846417/Extemporaneous+Essay.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e0c1e5b6c3aa8039c3e/1485667852801/Extemporaneous+Speaking.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e1146c3c4023d82d555/1485667858578/Fashion+Design.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e183a0411d31b4498f9/1485667864863/Graphic+Design.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e242e69cf76b7569607/1485667876517/Knowledge+Tests.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e33e6f2e152d3e2489d/1485667892131/MIST+Bowl.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d849dd1758e87f05fdb9b/1485669534042/Math+Olympics.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e3db3db2b428d8c2037/1485667901837/Mobile+Applications.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e481e5b6c3aa8039de4/1485667912453/Nasheed+and+Rap.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e4f46c3c4023d82d703/1485667919539/Original+Oratory.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d808bb3db2b428d8c3015/1485668492248/Photography.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d80a1e4fcb5a6cdc37e95/1485668514129/Poetry+Literature.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d80e9be6594f328541a31/1485668586010/Poetry+Spoken+Word.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d814f5016e177f5435b4a/1485668687867/Prepared+Essay.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d816303596e0fcbc10050/1485668708157/Quran.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d8173725e2506f4bbf4c1/1485668724184/Science+Fair.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d8190f7e0ab9c094d4f03/1485668753085/Short+Fiction.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d81ada5790aa54e5d75d3/1485668781566/Short+Film.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7dd603596e0fcbc0e989/1485667798080/Basketball.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d7e1e1b631b0e7cf6d19f/1485667870356/Improv.pdf",
        "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/588d81bcf7e0ab9c094d4ff7/1485668796254/Social+Media.pdf"]
    let ref:FIRDatabaseReference = FIRDatabase.database().reference(withPath: "competition")
    let resultref:FIRDatabaseReference = FIRDatabase.database().reference(withPath: "mist_2017_bracket")
    var resultArray:NSDictionary = [:]
    var results:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        rulesButton.layer.cornerRadius = 15.0
        rulesButton.layer.masksToBounds = true
        bracketsButton.layer.cornerRadius = 15.0
        bracketsButton.layer.masksToBounds = true
        self.myPicker.selectRow(13, inComponent: 0, animated: true)
        self.bracketsButton.isEnabled = true

        resultref.observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String:Any] {
                self.results = value
            }
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            if let indx = self.myPicker?.selectedRow(inComponent: 0) {
                if (bracketList.contains(self.competitionList[indx])) {
                    bracketsButton.isEnabled = true
                    bracketsButton.alpha = 1.0
                } else {
                    bracketsButton.isEnabled = false
                    bracketsButton.alpha = 0.4
                }
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewBracket(_ sender: UIButton) {
        let compName = self.competitionList[myPicker.selectedRow(inComponent: 0)]
        // Get result
        if (bracketList.contains(compName)) {
            self.resultArray = self.results[compName] as! NSDictionary
        }
        self.performSegue(withIdentifier: "brackets", sender: nil)
    }
    @IBAction func viewRules(_ sender: UIButton) {
//        if let url = URL(string: "https://static1.squarespace.com/static/5670ede7a976af3e2f3af0af/t/5869929b20099ecdf7a0dc22/1483313820637/Culinary+Arts+Ballot+pdf.pdf") {
//            UIApplication.shared.open(url)
//        }
        let url = urlList[self.myPicker.selectedRow(inComponent: 0)]
        let svc = SFSafariViewController(url: URL(string: url)!)
        self.present(svc,animated:true, completion:nil)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.competitionList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (self.bracketList.contains(self.competitionList[row])) {
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
        return (self.competitionList[row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "brackets") {
            if let DestVC = segue.destination as? BracketDetailVC {
                DestVC.titleString = self.competitionList[myPicker.selectedRow(inComponent: 0)]
                DestVC.resultArray = self.resultArray
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
