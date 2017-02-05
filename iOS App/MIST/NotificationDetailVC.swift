//
//  NotificationDetailVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 1/25/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit

class NotificationDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var myView: UIView!
    var titleText:String = ""
    var timeText:String = ""
    var bodyText:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 15.0
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        myView.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView.layer.shadowOpacity = 0.8
        titleLabel.text = titleText
        time.text = timeText
        body.text = bodyText
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        performSegue(withIdentifier: "unwind", sender: self)
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
