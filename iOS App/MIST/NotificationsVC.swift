//
//  NotificationsVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/24/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedNotification:[String:Any] = [:]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var notificationBodyLabel: UILabel!
    @IBOutlet weak var darkView: UIView!
    var isShowingNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationView.layer.cornerRadius = 15.0
        notificationView.layer.masksToBounds = false
        notificationView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        notificationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        notificationView.layer.shadowOpacity = 0.8
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
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if(settings.authorizationStatus != .authorized)
                {
                    DispatchQueue.main.async {
                        self.defaultLabel.text = "You have not enabled push notifications for MIST Atlanta"
                    }
                } else if self.defaultLabel.text != "You have no notifications" {
                    DispatchQueue.main.async {
                        self.defaultLabel.text = "You have no notifications"
                    }
                }
            }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var notifications = UserDefaults.standard.value(forKey: "notifications") as! [[String:Any]]
            notifications.remove(at: indexPath.row)
            UserDefaults.standard.set(notifications, forKey: "notifications")
            tableView.deleteRows(at: [indexPath], with: .fade)
            var count = 0
            for notification:[String:Any] in notifications {
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((UserDefaults.standard.value(forKey: "notifications") as? [NSDictionary]) ?? []).count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        notificationTitleLabel.text = self.selectedNotification["title"] as? String ?? "Title"
        notificationTimeLabel.text = self.selectedNotification["time"] as? String ?? ""
        notificationBodyLabel.text = self.selectedNotification["body"] as? String ?? ""
        
        notificationView.isHidden = false
        darkView.isHidden = false
        isShowingNotification = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isShowingNotification) {
            notificationView.isHidden = true
            darkView.isHidden = true
            isShowingNotification = false
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(((UserDefaults.standard.value(forKey: "notifications") as! [[String:AnyObject]])[indexPath.row] )["title"]!)"
        let date:NSDate = ((UserDefaults.standard.value(forKey: "notifications") as! [[String:AnyObject]])[indexPath.row] )["time"]! as! NSDate
        let seconds:Int = -1*Int(date.timeIntervalSinceNow)
        var unit = ""
        let hours = seconds / 3600;
        let days = hours / 24;
        let mins = (seconds % 3600) / 60;
        let secs = seconds % 60;
        if days > 1 {
            unit = "\(days) days"
        } else if (hours > 1) {
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
   

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
