//
//  SideMenuVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/3.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var profile_img: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var location_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    @IBAction func setting_btn_click(_ sender: Any) {
        let navigationController = UINavigationController.init(rootViewController: FilterVC())
        navigationController.navigationBar.isHidden = true
        slideMenuController.closeMenuBehindContentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func terms_btn_click(_ sender: Any) {
    }
    
    @IBAction func logout_btn_click(_ sender: Any) {
        let navigationController = UINavigationController.init(rootViewController: LoginVC())
        navigationController.navigationBar.isHidden = true
        slideMenuController.closeMenuBehindContentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        self.navigationController?.isNavigationBarHidden = true
        
        profile_img.layer.shadowRadius = 2
        profile_img.layer.shadowOpacity = 0.3
        profile_img.layer.shadowColor = UIColor(hex: "#7b7b7b").cgColor
        profile_img.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        profile_img.generateOuterShadow()
        
        let image = location_btn.image(for: .normal)
        location_btn.setImage(image?.imageWithColor(color: UIColor(hex: "#999999")), for: .normal)
    }
}
