//
//  Ext_UIView.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    func showToast(message: String) {
        DispatchQueue.main.async {
            let width = message.widthOfString(font: UIFont(name: "Helvetica Neue", size: 13)!) + 40
            let toastLabel = UILabel(frame: CGRect(x: (self.frame.size.width-width)/2, y: self.frame.size.height-50, width: width, height: 30))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            toastLabel.textColor = UIColor.white
            toastLabel.font = UIFont(name: "Helvetica Neue", size: 13)
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 15;
            toastLabel.clipsToBounds  =  true
            self.addSubview(toastLabel)
            UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    func showHUD(_ msg : String) {
        DispatchQueue.main.async{
            self.isUserInteractionEnabled = false
            let progressHUD = MBProgressHUD.showAdded(to: self, animated: true)
            progressHUD.label.text = msg
            progressHUD.bezelView.color = .black
            progressHUD.bezelView.style = .solidColor
            progressHUD.contentColor = .white
        }
    }
        
    func dismissHUD() {
        DispatchQueue.main.async{
            self.isUserInteractionEnabled = true
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
    
    enum ViewSide {
        case left, right, top, bottom
    }

    func addBorder(side: ViewSide, color: CGColor, thick: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .left: border.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: thick, height: self.frame.size.height)
        case .right: border.frame = CGRect(x: self.frame.size.width - thick, y: self.frame.origin.y, width: thick, height: self.frame.size.height)
        case .top: border.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: thick)
        case .bottom: border.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height - thick, width: self.frame.size.width, height: thick)
        }
        self.layer.addSublayer(border)
    }
    
    func makeTextWrapper(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.dropShadow(color: UIColor.darkGray, offSet: CGSize(width: 0, height: 1))
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.masksToBounds = false
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addGrdient (mainColor :[CGColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = mainColor
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func drawDottedLine(_ color: UIColor, width: CGFloat) {
        self.layoutIfNeeded()
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.layer.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 2).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint: CGPoint {
        return points.startPoint
    }
    
    var endPoint: CGPoint {
        return points.endPoint
    }
    
    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}

