//
//  MatchResultVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class MatchResultVC: UIViewController {

    @IBOutlet weak var menu_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        menu_btn.addTarget(self.slideMenuController, action: #selector(slideMenuController.toggleMenuAnimated(_:)), for: .touchUpInside)
        
    }
}
