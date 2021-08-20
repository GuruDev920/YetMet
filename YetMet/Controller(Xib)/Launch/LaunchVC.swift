//
//  LaunchVC.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }
}
