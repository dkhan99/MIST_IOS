//
//  ScheduleVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/27/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit

class ScheduleVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                // Do any additional setup after loading the view.
    }
    

    
    @IBAction func viewSchedule(_ sender: UIButton) {
        if let url = URL(string: "http://www.mistatlanta.com/s/School-Permission-Form.pdf") {
            UIApplication.shared.open(url)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
