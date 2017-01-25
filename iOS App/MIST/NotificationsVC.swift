//
//  NotificationsVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/24/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
    }
    @IBAction func deleteAll(_ sender: UIButton) {
        let empty : [NSDictionary] = []
        UserDefaults.standard.set(empty, forKey: "notifications")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((UserDefaults.standard.value(forKey: "notifications") as? [NSDictionary]) ?? []).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ((UserDefaults.standard.value(forKey: "notifications") as! [[String:AnyObject]])[indexPath.row] )["title"] as! String?
        cell.imageView?.image = #imageLiteral(resourceName: "Reddot.png")
        return cell
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
