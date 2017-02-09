//
//  BracketDetailVC.swift
//  
//
//  Created by Muhammad Doukmak on 1/5/17.
//
//

import UIKit

class BracketDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var titleString: String = ""
    var resultArray:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleString
        navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = self.titleString
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.resultArray[section] as [String:Any])["participantArray"] as! [String]).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MISTTableViewCell
        cell.nameLabel?.text = ((self.resultArray[indexPath.section] as [String:Any])["participantArray"] as? [String])?[indexPath.row]
        cell.numberLabel?.text = ""
        return cell

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resultArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.resultArray[section]["title"] as! String?
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
