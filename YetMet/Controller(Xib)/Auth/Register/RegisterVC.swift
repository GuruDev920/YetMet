//
//  RegisterVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var profile_img: UIImageView!
    @IBOutlet weak var username_text: UITextField!
    @IBOutlet weak var fullname_text: UITextField!
    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var password_text: UITextField!
    @IBOutlet weak var login_btn: UILocalizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_UI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func profile_btn_click(_ sender: Any) {
        
    }
    
    @IBAction func create_btn_click(_ sender: Any) {
        self.navigationController?.viewControllers.removeAll()
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.setRootViewController(MainVC())
    }
    
    @IBAction func facebook_btn_click(_ sender: Any) {
    }
    
    @IBAction func login_btn_click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        username_text.delegate = self
        fullname_text.delegate = self
        email_text.delegate = self
        password_text.delegate = self
        
        let text = login_btn.titleLabel?.text
        let nsText = text! as NSString
        let range = nsText.range(of: NSLocalizedString("Login", comment: ""))
        let attributedText = NSMutableAttributedString(string: login_btn.titleLabel?.text ?? "")
        attributedText.addAttributes([.foregroundColor : UIColor(hex: "#efb4d5")], range: range)
        login_btn.titleLabel?.attributedText = attributedText
    }
}

//MARK: - UITextFieldDelegate
extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
