//
//  UILocalizedButton.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class UILocalizedButton: UIButton {

    @IBInspectable var keyString: String = "" {
        didSet {
            self.setTitle(NSLocalizedString(self.keyString, comment: self.commentString), for: .normal)
        }
    }
    
    @IBInspectable var commentString: String = "" {
        didSet {
            self.setTitle(NSLocalizedString(self.keyString, comment: self.commentString), for: .normal)
        }
    }
}
