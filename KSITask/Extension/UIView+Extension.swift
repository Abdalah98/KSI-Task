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
    
  
  
   
    
    func shadow() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 8, height: 8)
      self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
    }
  
  func presentChildVC(in parent: UIViewController, with vc: UIViewController)
  { self.addSubview(vc.view)
    vc.view.bounds = self.bounds
    vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    vc.didMove(toParent: parent)
    vc.view.fillSuperView()
    
  }
  
  
  func removeChildVC (with vc: UIViewController) {
    vc.willMove(toParent: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParent() }
  
  func fillSuperView(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superviewTopAnchor = superview?.topAnchor { topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true }
    if let superviewBottomAnchor = superview?.bottomAnchor { bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true }
    if let superviewLeadingAnchor = superview?.leadingAnchor { leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true }
    if let superviewTrailingAnchor = superview?.trailingAnchor { trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true } }









  func addDottedLine() {
      backgroundColor = UIColor.clear
      
      let shapeLayer = CAShapeLayer()
      shapeLayer.strokeColor = UIColor.red.cgColor
      shapeLayer.lineWidth = 0.5
      shapeLayer.lineDashPattern = [4, 4] // [dash length, gap length]

      let path = UIBezierPath()
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: self.bounds.width + 40, y: 0))

      shapeLayer.path = path.cgPath
      clipsToBounds = true

      // Add the shape layer as a sublayer to the view's layer
      self.layer.addSublayer(shapeLayer)
  }






  
    
    func verticalGradient(_ startColor: UIColor, _ endColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [startColor, endColor]
        gradient.locations = [0, 0.25, 1]
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
    

    
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
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

