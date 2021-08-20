//
//  SearchVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var menu_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    @IBAction func filter_btn_click(_ sender: Any) {
        self.navigationController?.pushViewController(FilterVC(), animated: true)
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        menu_btn.addTarget(self.slideMenuController, action: #selector(slideMenuController.toggleMenuAnimated(_:)), for: .touchUpInside)
    }
}
