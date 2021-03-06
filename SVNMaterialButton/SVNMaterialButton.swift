//
//  SVNMaterialButton.swift
//  SVNLargeButton
//
//  Created by Aaron Dean Bikis on 4/7/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import UIKit
import SVNTheme
import DeviceKit

open class SVNMaterialButton: UIButton {
  
  open class var standardHeight: CGFloat! {
    get {
      let device = Device()
      if device.isOneOf([.iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE]) {
        return 45.0
      }
      if device.isOneOf([.iPhone6, .iPhone6s, .iPhone7, .iPhone8]) {
        return 55.0
      }
      return 65.0
    }
  }
  
  open class var standardPadding: CGFloat! {
    get {
      return 15.0
    }
  }
  
  open class var bottomPadding: CGFloat {
    get {
      let device = Device()
      if device.isOneOf([.iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE]) {
        return 25.0
      }
      if device.isOneOf([.iPhone6, .iPhone6s, .iPhone7, .iPhone8]) {
        return 25.0
      }
      return 35.0
    }
  }
  
  override open var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ?
        viewModel.enabledColor :
        viewModel.disabledColor
    }
  }
  
  
  private var borderLayer: CAShapeLayer?
  
  
  private var viewModel: SVNMaterialButtonViewModel
  
  
  public init(frame: CGRect, viewModel: SVNMaterialButtonViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    setUI()
  }
  
  
  private func setMaterialUI(){
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.8
    self.layer.shadowRadius = 8
    self.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
  }
  
  
  private func setUI(){
    backgroundColor = viewModel.enabledColor
    
    titleLabel?.font = viewModel.font
    titleLabel?.textColor = UIColor.white
    setTitleColor(viewModel.textColor, for: UIControlState())
    setTitle(viewModel.text, for: UIControlState())
    
    if viewModel.isRounded { layer.cornerRadius = 10 }
    setMaterialUI()
  }
  
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("This class is not set up to be instaciated with coder use init(frame) instead")
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height / 4
  }
  
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.animate(to: 0.5, and: CGSize(width: 5.0, height: 5.0), with: 0.5)
  }
  
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.sendActions(for: .touchUpInside)
    self.animate(to: 0.8, and: CGSize(width: 8.0, height: 8.0), with: 0.5)
  }
  
  private func animate(to opacity: Double, and offset: CGSize, with duration: Double){
    CATransaction.begin()
    let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
    opacityAnimation.toValue = opacity
    opacityAnimation.duration = duration
    opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    opacityAnimation.fillMode = kCAFillModeBoth
    opacityAnimation.isRemovedOnCompletion = false
    
    let offsetAnimation = CABasicAnimation(keyPath: "shadowOffset")
    offsetAnimation.toValue = offset
    offsetAnimation.duration = duration
    offsetAnimation.timingFunction = opacityAnimation.timingFunction
    offsetAnimation.fillMode = opacityAnimation.fillMode
    offsetAnimation.isRemovedOnCompletion = false
    
    self.layer.add(offsetAnimation, forKey: offsetAnimation.keyPath!)
    self.layer.add(opacityAnimation, forKey: opacityAnimation.keyPath!)
    CATransaction.commit()
  }
}
