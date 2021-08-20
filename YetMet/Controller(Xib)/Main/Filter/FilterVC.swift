//
//  FilterVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/3.
//

import UIKit

class FilterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.viewControllers.removeAll()
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.setRootViewController(MainVC(), direction: .toLeft)
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        
    }
}
