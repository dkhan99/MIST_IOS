//
//  ScheduleVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/27/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ScheduleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    var items: [[String:Any]] = []
    var user: User!
    let dayArray = ["Friday","Saturday","Sunday"]
    let ref = FIRDatabase.database().reference(withPath: "competition_test")
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var scheduleItems:[[[String:Any]]] = [[],[],[]]
    var competitions:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            let mistUser = UserDefaults.standard.value(forKey: "user") as! [String:Any]
            if (mistUser["userType"] as! String == "competitor") {
                var registeredCompetitions:[String] = []
                if let groupProject = mistUser["groupProject"] {
                    if(groupProject as! String != "") {
                        registeredCompetitions.append(groupProject as! String)
                    }
                }
                if let knowledge = mistUser["knowledge"] {
                    if(knowledge as! String != "") {
                        registeredCompetitions.append(knowledge as! String)
                    }
                }
                if let art = mistUser["art"] {
                    if(art as! String != "") {
                        registeredCompetitions.append(art as! String)
                    }
                }
                
                if let sports = mistUser["sports"] {
                    if (sports as! String != "") {
                        registeredCompetitions.append(sports as! String)
                    }
                }
                if let writing = mistUser["writing"] {
                    if (writing as! String != "") {
                        registeredCompetitions.append(writing as! String)
                    }
                }
                
                for item in snapshot.children {
                    let comp = Competition(snapshot: item as! FIRDataSnapshot)
                    if (registeredCompetitions.contains(comp.name)) {
                        // User is registered for this competition
                        for location:[String:Any] in comp.locationArray {
                            var loc = location
                            loc["name"] = comp.name
                            let dateString = "\(location["date"]!) \(location["time"]!)"
                            let formatter:DateFormatter = DateFormatter()
                            formatter.dateFormat="MM/dd/yy HH:mm"
                            let date = formatter.date(from: dateString)
                            loc["date"] = date
                            let dformatter:DateFormatter = DateFormatter()
                            dformatter.dateFormat = "EEEE"
                            self.scheduleItems[self.dayArray.index(of: dformatter.string(from: date!))!].append(loc)
                        }
                        self.scheduleItems[0].sort(by: {
                            ($0["date"] as! Date) < ($1["date"] as! Date)
                        })
                        self.scheduleItems[1].sort(by: {
                            ($0["date"] as! Date) < ($1["date"] as! Date)
                        })
                        self.scheduleItems[2].sort(by: {
                            ($0["date"] as! Date) < ($1["date"] as! Date)
                        })
                        //self.scheduleItems.sort(by: {$0["date"] as! Date > $1["date"] as! Date} )
                    }
                }
                
                self.myTable.reloadData()
                
            }
            
        })
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(data: user)
        }
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MISTTableViewCell
        cell.nameLabel?.text = "\(self.scheduleItems[indexPath.section][indexPath.row]["time"] as! String) - \(self.scheduleItems[indexPath.section][indexPath.row]["name"] as! String)"
        cell.numberLabel?.text = "\(self.scheduleItems[indexPath.section][indexPath.row]["location"] as! String) \(self.scheduleItems[indexPath.section][indexPath.row]["roomNum"]!)"
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dayArray[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleItems[section].count
    }
    
    
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.performSegue(withIdentifier: "unwindToMIST", sender: self)
            
            self.segment.selectedSegmentIndex = 1
            // Send USER DATA HERE
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
