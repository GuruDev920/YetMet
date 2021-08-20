//
//  Ext_UITextField.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit
import Foundation

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setBorder() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.setLeftPaddingPoints(10)
    }
    
    func setCornerBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.setLeftPaddingPoints(10)
        self.setRightPaddingPoints(10)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable var localizedPlaceholder: String {
        get {
            return ""
        }
        set {
            self.placeholder = newValue
        }
    }
    
    @IBInspectable var localizedText: String {
        get {
            return ""
        }
        set {
            self.text = newValue
        }
    }
}

