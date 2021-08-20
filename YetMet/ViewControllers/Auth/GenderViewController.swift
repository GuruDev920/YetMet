//
//  GenderViewController.swift
//  YetMet
//
//  Created by Sun on 2021/8/5.
//

import UIKit

class GenderViewController: UIViewController {

    @IBOutlet var markers: [UIView]!
    @IBOutlet var dots: [UIImageView]!
    @IBOutlet var btns: [UIButton]!
    
    var userpf = NSMutableDictionary()
    private var isMale = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func select_gender(_ sender: UIButton) {
        isMale = sender.tag == 0
        markers[sender.tag].backgroundColor = UIColor(hex: "#FFA8CB")
        markers[1 - sender.tag].backgroundColor = UIColor(hex: "#BFBDBD")
        dots[sender.tag].image = UIImage(systemName: "dot.circle")?.tintColor(color: UIColor(hex: "#FFA8CB"))
        dots[1-sender.tag].image = UIImage(systemName: "circle")?.tintColor(color: UIColor(hex: "#BFBDBD"))
    }
    
    @IBAction func next_btn_click(_ sender: Any) {
        userpf.setValue(isMale ? 1 : 2, forKey: u_gender)
        userpf.setValue(isMale ? 2 : 1, forKey: u_interested)
        
        let vc = self.storyboard?.instantiateViewController(identifier: "FillViewController") as! FillViewController
        vc.isMale = self.isMale
        vc.userpf = userpf
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func init_UI() {
        self.select_gender(btns[0])
    }
}
