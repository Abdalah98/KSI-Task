//
//  OnboardingVC.swift
//  WinWin
//
//  Created by Ahmed Sayed Fathi on 02/06/2022.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


extension UIView {
    
  
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
    func shadow() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 8, height: 8)
      self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
    }

 
}

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}

