//
//  Ext_UIViewController.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import Foundation
import UIKit
import MBProgressHUD
import FirebaseAuth
import SCLAlertView

public extension UIWindow {
    struct TransitionOptions {
        public enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear:    key = CAMediaTimingFunctionName.linear.rawValue
                case .easeIn:    key = CAMediaTimingFunctionName.easeIn.rawValue
                case .easeOut:   key = CAMediaTimingFunctionName.easeOut.rawValue
                case .easeInOut: key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
                }
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key!))
            }
        }
        
        public enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight
            /// Return the associated transition
            /// - Returns: transition
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade:
                    transition.type = CATransitionType.fade
                    transition.subtype = nil
                case .toLeft:
                    transition.subtype = CATransitionSubtype.fromLeft
                case .toRight:
                    transition.subtype = CATransitionSubtype.fromRight
                case .toTop:
                    transition.subtype = CATransitionSubtype.fromTop
                case .toBottom:
                    transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }
        
        public enum Background {
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }
        
        public var duration: TimeInterval = 0.3
        public var direction: TransitionOptions.Direction = .toRight
        public var style: TransitionOptions.Curve = .easeInOut
        public var background: TransitionOptions.Background? = nil
        public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }
        
        public init() { }
        
        internal var animation: CATransition {
            let transition = self.direction.transition()
            transition.duration = self.duration
            transition.timingFunction = self.style.function
            return transition
        }
    }
    
    func setRootViewController(_ controller: UIViewController, direction: UIWindow.TransitionOptions.Direction = .toRight) {
        let options = UIWindow.TransitionOptions(direction: direction, style: .easeIn)
        var transitionWnd: UIWindow? = nil
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
            switch background {
            case .customView(let view):
                transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
            case .solidColor(let color):
                transitionWnd?.backgroundColor = color
            }
            transitionWnd?.makeKeyAndVisible()
        }
        // Make animation
        self.layer.add(options.animation, forKey: kCATransition)
        
        let menuVC = SideMenuVC()
        let menuNavigationController = UINavigationController.init(rootViewController: menuVC)
        let navigationController = UINavigationController.init(rootViewController: controller)
        navigationController.navigationBar.isTranslucent = false
        let slideMenuVC = NVSlideMenuController.init(menuViewController: menuNavigationController, andContentViewController: navigationController)
        
        self.rootViewController = slideMenuVC
        self.makeKeyAndVisible()
        
        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.5 + options.duration), execute: {
                wnd.removeFromSuperview()
            })
        }
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showCameraAlert() {
        self.selectAlert(ShareData.appName, "Please select photo.", 3, ["Camera", "Gallery", "Cancel"], [UIColor.blue, UIColor.blue, UIColor.red], [.white, .white, .white], self, [#selector(ImageFromCamera(_:)), #selector(ImageFromGallary(_:)), #selector(blankAction(_:))])
    }
    
    @objc func ImageFromGallary(_ sender: UIButton) {
        let picker = UIImagePickerController.init()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.navigationBar.tintColor = UIColor.white
        picker.navigationBar.barTintColor = UIColor.gray
        present(picker, animated: true, completion: nil)
    }
        
    @objc func ImageFromCamera(_ sender: UIButton) {
        let picker = UIImagePickerController.init()
        picker.allowsEditing = true
        picker.delegate = self
        
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        picker.navigationBar.tintColor = UIColor.white
        picker.navigationBar.barTintColor = UIColor.gray
        present(picker, animated: true, completion: nil)
    }
    
    @objc func blankAction(_ sender: UIButton) {
        print("No Action")
    }
}

extension UIViewController  {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showHUD(_ msg: String = "") {
        DispatchQueue.main.async{
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = msg
            progressHUD.bezelView.color = .black
            progressHUD.bezelView.style = .solidColor
            progressHUD.contentColor = .white
        }
    }
        
    func dismissHUD() {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func showToast(message : String) {
        DispatchQueue.main.async {
            let width = message.widthOfString(font: UIFont(name: "Helvetica Neue", size: 13)!) + 40
            let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width-width)/2, y: self.view.frame.size.height-50, width: width, height: 30))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            toastLabel.textColor = UIColor.white
            toastLabel.font = UIFont(name: "Helvetica Neue", size: 13)
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 15;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    func addSwipeRight(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
        
    @objc func swipeRight(gesture: UISwipeGestureRecognizer){
        if(self.navigationController != nil){
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func doneAlert(_ subtitle: String, _ btn_title: String, _ completionHandler: @escaping () -> Void) {
            let appearance = SCLAlertView.SCLAppearance(
                kDefaultShadowOpacity: 0.6,
                kCircleIconHeight: 60,
                showCloseButton: false,
                showCircularIcon: true
            )
            
        DispatchQueue.main.async {
            let alertView = SCLAlertView(appearance: appearance)
            let alertViewIcon = UIImage(named: "mark")
            alertView.addButton(btn_title, backgroundColor: UIColor.blue, textColor: UIColor.white, action: completionHandler)
            alertView.showInfo(ShareData.appName, subTitle: subtitle, circleIconImage: alertViewIcon)
        }
    }
        
    func selectAlert(_ title: String, _ subtitle: String, _ btn_num: Int, _ btn_titles: [String], _ btn_colors: [UIColor], _ btn_txt_colors: [UIColor], _ target: AnyObject, _ btn_actions: [Selector]) {
        let appearance = SCLAlertView.SCLAppearance(
            kDefaultShadowOpacity: 0.6,
            kCircleIconHeight: 60,
            showCloseButton: false,
            showCircularIcon: true
        )
        
        DispatchQueue.main.async {
            let alertView = SCLAlertView(appearance: appearance)
            let alertViewIcon = UIImage(named: "mark")
            for i in 0..<btn_num {
                alertView.addButton(btn_titles[i], backgroundColor: btn_colors[i], textColor: btn_txt_colors[i], target: target, selector: btn_actions[i])
            }
            alertView.showInfo(title, subTitle: subtitle, circleIconImage: alertViewIcon)
        }
    }
    
    func inputAlert(_ title: String, _ subtitle: String, _ default_txt: String, _ btn_num: Int, _ btn_titles: [String], _ btn_colors: [UIColor], _ btn_txt_colors: [UIColor], _ target: AnyObject, _ btn_actions: [Selector]) -> UITextField {
        let appearance = SCLAlertView.SCLAppearance(
            kDefaultShadowOpacity: 0.6,
            kCircleIconHeight: 60,
            showCloseButton: false,
            showCircularIcon: true
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "mark")
        let txt = alertView.addTextField(default_txt)
        for i in 0..<btn_num {
            alertView.addButton(btn_titles[i], backgroundColor: btn_colors[i], textColor: btn_txt_colors[i], target: target, selector: btn_actions[i])
        }
        
        alertView.showInfo(title, subTitle: subtitle, circleIconImage: alertViewIcon)
        
        return txt
    }
        
    func disappearAlert(_ subtitle: String, _ completionHandler: @escaping () -> Void) {
        let appearance = SCLAlertView.SCLAppearance(
            kDefaultShadowOpacity: 0.6,
            kCircleIconHeight: 60,
            showCloseButton: false,
            showCircularIcon: true
        )
        
        DispatchQueue.main.async {
            let alertView = SCLAlertView(appearance: appearance)
            let alertViewIcon = UIImage(named: "mark")
            let timeoutValue: TimeInterval = 1.0
            let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = completionHandler
            
            alertView.showInfo(ShareData.appName, subTitle: subtitle, timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction), circleIconImage: alertViewIcon)
        }
    }
}

internal extension UIViewController {
    
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
}
