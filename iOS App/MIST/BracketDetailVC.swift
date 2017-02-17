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
    var resultArray:NSDictionary = [:]
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
        return (self.resultArray.value(forKey: self.resultArray.allKeys[section] as! String) as! [[String:Any]]).count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Montserrat-Regular", size: 16)!
        title.textColor = UIColor.darkGray
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font=title.font
        header.textLabel!.textColor = title.textColor
        header.contentView.backgroundColor = UIColor.white
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MISTTableViewCell
        cell.nameLabel?.text = ((self.resultArray.value(forKey: self.resultArray.allKeys[indexPath.section] as! String) as! [[String:Any]])[indexPath.row])["teamName"] as! String?
        cell.numberLabel?.text = "\(((self.resultArray.value(forKey: self.resultArray.allKeys[indexPath.section] as! String) as! [[String:Any]])[indexPath.row])["day"] as! String) \(((self.resultArray.value(forKey: self.resultArray.allKeys[indexPath.section] as! String) as! [[String:Any]])[indexPath.row])["time"] as! String) - \(((self.resultArray.value(forKey: self.resultArray.allKeys[indexPath.section] as! String) as! [[String:Any]])[indexPath.row])["building"] as! String) \(((self.resultArray.value(forKey: self.resultArray.allKeys[indexPath.section] as! String) as! [[String:Any]])[indexPath.row])["room"] as! String)"
        return cell

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resultArray.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.resultArray.allKeys[section] as? String
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
