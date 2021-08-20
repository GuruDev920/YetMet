//
//  MainVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet var bottom_btns: [UIButton]!
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var center_btn_view: UIView!
    @IBOutlet weak var badge: UIView!
    
    private let vcs = [ProfileVC(), SearchVC(), MatchResultVC()]
    var vc: UIViewController!
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    @IBAction func bottom_btns_click(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        vc = vcs[selectedIndex]
        if !sender.isSelected {
            bottom_btns[previousIndex].isSelected = false
            let previousVC = vcs[previousIndex]
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            addChild(vc)
            vc.view.frame = container.bounds
            container.addSubview(vc.view)
            
            sender.isSelected = !sender.isSelected
        }
    }
    
    // MARK: - UI functions
    
    func init_UI() {
        self.navigationController?.isNavigationBarHidden = true
        
        bottom_view.layer.cornerRadius = 20
        bottom_view.layer.shadowRadius = 4.0
        bottom_view.layer.shadowOpacity = 0.5
        bottom_view.layer.shadowColor = UIColor.lightGray.cgColor
        bottom_view.layer.shadowOffset = CGSize.zero
        bottom_view.generateOuterShadow()

        center_btn_view.layer.cornerRadius = 45
        center_btn_view.layer.shadowRadius = 2
        center_btn_view.layer.shadowOpacity = 0.5
        center_btn_view.layer.shadowColor = UIColor.lightGray.cgColor
        center_btn_view.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        center_btn_view.generateOuterShadow()
        
        bottom_btns_click(bottom_btns[selectedIndex])
    }
}
