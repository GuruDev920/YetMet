//
//  UILocalizedLabel.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit

class UILocalizedLabel: UILabel {

    @IBInspectable var keyString: String = "" {
        didSet {
            self.text = NSLocalizedString(self.keyString, comment: self.commentString)
        }
    }
    
    @IBInspectable var commentString: String = "" {
        didSet {
            self.text = NSLocalizedString(self.keyString, comment: self.commentString)
        }
    }
}
