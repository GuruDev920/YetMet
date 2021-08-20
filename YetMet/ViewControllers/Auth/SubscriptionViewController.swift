//
//  SubscriptionViewController.swift
//  YetMet
//
//  Created by Sun on 2021/8/6.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController {
    
    @IBOutlet var items: [UIView]!
    @IBOutlet var backs: [UIView]!
    @IBOutlet var btns: [UIButton]!
    @IBOutlet var num_lbls: [UILabel]!
    @IBOutlet var period_lbls: [UILabel]!
    @IBOutlet var desc_lbls: [UILabel]!
    @IBOutlet var percent_lbls: [UILabel]!
    @IBOutlet var percent_mark_lbls: [UILabel]!
    @IBOutlet var off_lbls: [UILabel]!
    @IBOutlet var mark_back: [MaskView]!
    @IBOutlet var mark_back_imgs: [UIImageView]!

    var userpf = NSMutableDictionary()
    
    private var products = [SKProduct]()
    private let select_color = UIColor(hex: "#14A1C7")
    private var keys_iap = ["1week", "1month", "3months"]
    private var index = 1
    private var prev_index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
        getProducts()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func select_btn_click(_ sender: UIButton) {
        index = sender.tag
        if index == prev_index {
            return
        }
        for i in 0...2 {
            if i == index {
                backs[i].backgroundColor = .white
                backs[i].layer.borderWidth = 2.5
                backs[i].layer.borderColor = select_color.cgColor
                num_lbls[i].textColor = select_color
                period_lbls[i].textColor = select_color
                desc_lbls[i].textColor = select_color
                if i>0 {
                    mark_back_imgs[i-1].isHidden = false
                    percent_lbls[i-1].textColor = select_color
                    percent_mark_lbls[i-1].textColor = select_color
                    off_lbls[i-1].textColor = select_color
                }
            } else {
                backs[i].backgroundColor = .lightGray
                backs[i].layer.borderWidth = 0
                num_lbls[i].textColor = .darkGray
                period_lbls[i].textColor = .darkGray
                desc_lbls[i].textColor = .darkGray
                if i>0 {
                    mark_back_imgs[i-1].isHidden = true
                    percent_lbls[i-1].textColor = .white
                    percent_mark_lbls[i-1].textColor = .white
                    off_lbls[i-1].textColor = .white
                }
            }
            if i == index {
                items[i].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } else if i == prev_index {
                items[i].transform = CGAffineTransform.identity
            }
        }
        prev_index = index
    }
    
    @IBAction func subscribeAction(_ sender: Any) {
        if self.products.count < index+1 {
            return
        }
        let product = self.products[index]
        if self.purchase(product: product) {
            print("successfully purchased")
        }
    }
    
    func savePaid(_ product: SKProduct) {
        userpf.setValue(self.keys_iap[index], forKey: u_subcription_period)
        userpf.setValue(FieldValue.serverTimestamp(), forKey: u_subcription_date)
        
        self.createUserMan()
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        let product = self.products[index]
        self.restorePurchases(product: product)
    }
    
    // MARK: - Create Man
    func createUserMan() {
        self.showHUD()
        let email = userpf.object(forKey: u_email) as? String ?? ""
        let password = userpf.object(forKey: u_password) as? String ?? ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.dismissHUD()
            if let error = error as NSError? {
                var alertMsg:String = ""
                switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        alertMsg = NSLocalizedString("The operations is not allowed.", comment: "")
                      break
                    case .emailAlreadyInUse:
                        alertMsg = NSLocalizedString("Your email address is already in use.", comment: "")
                      print("emailAlreadyInUse")
                      break
                    case .invalidEmail:
                        alertMsg = NSLocalizedString("Your email address is malformed.", comment: "")
                      print("invalidEmail")
                      break
                    case .weakPassword:
                        alertMsg = NSLocalizedString("Your password is weak. Please try with strong password.", comment: "")
                      print("weakPassword")
                      break
                    default:
                        alertMsg = "Error: \(error.localizedDescription)"
                      print("Error: \(error.localizedDescription)")
                }
                let alertController = UIAlertController(title: L_ERROR, message: alertMsg, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: L_OK, style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let userId = Auth.auth().currentUser!.uid as String?
                self.userpf.setValue(userId, forKey: "userId")
                currentuser = self.userpf
                
                let ref = Database.database().reference()
                ref.child("users").child(userId!).setValue(self.userpf) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            getCurrentUser { (result) in
                              if result {
                                DispatchQueue.main.async {
                                    self.navigationController?.dismiss(animated: true, completion: nil)
                                }
                              }
                            }
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - Init UI
    func init_UI() {
        backs.forEach{$0.layer.cornerRadius = 10}
        select_btn_click(btns[index])
    }
}

// MARK: - In App Purchase
extension SubscriptionViewController {
    func getProducts() {
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let products):
                        self.products = products
                    case .failure(let error): self.showIAPRelatedError(error)
                }
            }
        }
    }
    
    func restorePurchases(product: SKProduct) {
        self.showHUD()
        IAPManager.shared.restorePurchases { (result) in
            self.dismissHUD()
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if success {
                        print("restored successfully")
                        self.showToast(message: "Successfully Restored.")
                        self.savePaid(product)
                    } else {
                        print("restore false")
                        self.showToast(message: "You didn't purchase yet.")
                    }
                case .failure(let error):
                    print(error)
                    self.showToast(message: error.localizedDescription)
                }
            }
        }
    }
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            self.showHUD()
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    self.dismissHUD()
                    switch result {
                    case .success(_):
                        self.savePaid(product)
                    case .failure(let error):
                        print(error)
                        self.showAlert(for: product)
                    }
                }
            }
        }
        return true
    }
    
    func showAlert(for product: SKProduct) {
        guard let price = IAPManager.shared.getPriceFormatted(for: product) else { return }
        
        let alertController = UIAlertController(title: product.localizedTitle, message: product.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Buy now for \(price)", style: .default, handler: { (_) in
            if !self.purchase(product: product) {
                self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { (_) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSingleAlert(withMessage message: String) {
        let alertController = UIAlertController(title: ShareData.appName, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showIAPRelatedError(_ error: Error) {
        let message = error.localizedDescription
        showSingleAlert(withMessage: message)
    }
}
