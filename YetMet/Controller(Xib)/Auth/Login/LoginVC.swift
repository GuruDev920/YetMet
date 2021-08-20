//
//  LoginVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var password_text: UITextField!
    @IBOutlet weak var signup_btn: UILocalizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_UI()
    }
    
    @IBAction func forgot_pwd_btn_click(_ sender: Any) {
    }
    
    @IBAction func login_btn_click(_ sender: Any) {
        self.navigationController?.viewControllers.removeAll()
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.setRootViewController(MainVC())
    }
    
    @IBAction func facebook_login_btn_click(_ sender: Any) {
        self.navigationController?.viewControllers.removeAll()
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.setRootViewController(MainVC())
    }
    
    @IBAction func signup_btn_click(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        email_text.delegate = self
        password_text.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
