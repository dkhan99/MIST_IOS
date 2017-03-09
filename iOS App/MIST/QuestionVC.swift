//
//  QuestionVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 3/8/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class QuestionVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        submitButton.isEnabled = false
        submitButton.alpha = 0.3
        for view:UIView in [textView, submitButton] {
            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowOpacity = 0.8
            view.layer.cornerRadius = 15.0
        }
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.contains("Type") {
            textView.text = ""
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        submitButton.isEnabled = textView.text != ""
        submitButton.alpha = textView.text != "" ? 1.0 : 0.3
    }
    @IBAction func submitQuestion(_ sender: UIButton) {
        self.ref.child("questions").childByAutoId().setValue(textView.text, withCompletionBlock: { (error, ref) in
            let alert:UIAlertController?
            if error == nil {
                alert = UIAlertController(title: "Question Submitted", message: "Thank you for submitting a question. Your question has been added to the list and will be presented to the workshop speakers", preferredStyle: .alert)
                alert!.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                
            } else {
                alert = UIAlertController(title: "Error submitting question", message: error?.localizedDescription, preferredStyle: .alert)
                alert!.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    _ = self.navigationController?.popViewController(animated: true)
                }))

            }
            self.present(alert!, animated: true, completion: nil)
        })
        
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
