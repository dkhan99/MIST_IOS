//
//  NotificationsVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/24/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedNotification:[String:Any] = [:]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var defaultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let not = (UserDefaults.standard.value(forKey: "notifications") as? [NSDictionary]) {
            if (not.isEmpty) {
                tableView.isHidden = true
                defaultLabel.isHidden = false
            } else {
                tableView.reloadData()
                tableView.isHidden = false
                defaultLabel.isHidden = true
            }
        } else {
            tableView.isHidden = true
            defaultLabel.isHidden = false
        }

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        
    }
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        let empty : [NSDictionary] = []
        UserDefaults.standard.set(empty, forKey: "notifications")
        self.tabBarController?.tabBar.items?[4].badgeValue = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.tableView.reloadData()
        tableView.isHidden = true
        defaultLabel.isHidden = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((UserDefaults.standard.value(forKey: "notifications") as? [NSDictionary]) ?? []).count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                var currentNotifications:[[String:Any]] = []
        if (UserDefaults.standard.value(forKey: "notifications") != nil) {
            currentNotifications = UserDefaults.standard.value(forKey: "notifications") as! [[String:Any]]
        }
        (currentNotifications[indexPath.row])["read"] = true
        UserDefaults.standard.setValue(currentNotifications, forKey: "notifications")
        var count = 0
        for notification:[String:Any] in currentNotifications {
            if notification["read"] as! Bool == false {
                count+=1
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = count
        if count>0 {
            self.tabBarController?.tabBar.items?[4].badgeValue = "\(count)"
        } else {
            self.tabBarController?.tabBar.items?[4].badgeValue = nil
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        self.selectedNotification = currentNotifications[indexPath.row]
        selectedNotification["time"] = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(((UserDefaults.standard.value(forKey: "notifications") as! [[String:AnyObject]])[indexPath.row] )["title"]!)"
        let date:NSDate = ((UserDefaults.standard.value(forKey: "notifications") as! [[String:AnyObject]])[indexPath.row] )["time"]! as! NSDate
        let seconds:Int = -1*Int(date.timeIntervalSinceNow)
        var unit = ""
        let hours = seconds / 3600;
        let mins = (seconds % 3600) / 60;
        let secs = seconds % 60;
        if (hours > 1) {
            unit = "\(hours) hours"
        } else if (mins > 1) {
            unit = "\(mins) min"
        } else {
            unit = "\(secs) sec"
        }
        cell.detailTextLabel?.text = unit + " ago"
        if ((UserDefaults.standard.value(forKey: "notifications") as? [NSDictionary])?[indexPath.row].value(forKey: "read") as! Bool == false) {
            //cell.textLabel?.text = "🔴 \(cell.textLabel!.text!)"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: (cell.textLabel?.font.pointSize)!)
            cell.imageView?.image = #imageLiteral(resourceName: "Reddot")
        } else {
            cell.imageView?.image = nil
            cell.textLabel?.font = UIFont.systemFont(ofSize: (cell.textLabel?.font.pointSize)!)
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func myNotificationUnwindAction(unwindSegue: UIStoryboardSegue){
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let destVC = segue.destination as! NotificationDetailVC
            destVC.titleText = self.selectedNotification["title"] as! String
            destVC.timeText = self.selectedNotification["time"] as! String
            destVC.bodyText = self.selectedNotification["body"] as! String
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
