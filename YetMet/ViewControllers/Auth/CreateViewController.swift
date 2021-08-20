//
//  CreateViewController.swift
//  YetMet
//
//  Created by Sun on 2021/8/5.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var username_text: UITextField!
    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var pwd_text: UITextField!
    @IBOutlet weak var confirm_pwd_text: UITextField!
    
    private var alertError: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if checkFields() {
            let userpf = NSMutableDictionary()
            userpf.setValue(username_text.text, forKey: u_username)
            userpf.setValue(email_text.text, forKey: u_email)
            userpf.setValue(pwd_text.text, forKey: u_password)
            
            let vc = self.storyboard?.instantiateViewController(identifier: "GenderViewController") as! GenderViewController
            vc.userpf = userpf
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertController = UIAlertController(title: L_ERROR, message: alertError, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: L_OK, style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkFields() -> Bool {
        if (username_text.text?.isEmpty ?? true) || (email_text.text?.isEmpty ?? true) || (pwd_text.text?.isEmpty ??  true) {
            alertError = NSLocalizedString("Oops! Text is empty", comment: "")
            return false
        } else if (username_text.text?.count ?? 0) < 4 {
            alertError = NSLocalizedString("Username should be more than 3", comment: "")
            return false
        } else if !email_text.text!.isValidEmailAddress() {
            alertError = NSLocalizedString("Invalid email address", comment: "")
            return false
        } else if (pwd_text.text?.count ?? 0) < 6 {
            alertError = NSLocalizedString("Password should be more than 5", comment: "")
            return false
        } else if confirm_pwd_text.text! != pwd_text.text! {
            alertError = NSLocalizedString("Passwords do not match", comment: "")
            return false
        }
        return true
    }
    
    func init_UI() {
        username_text.delegate = self
        email_text.delegate = self
        pwd_text.delegate = self
        confirm_pwd_text.delegate = self
    }
}

extension CreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
