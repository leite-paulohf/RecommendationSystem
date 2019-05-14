//
//  ActivityIndicatorView.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 19/05/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorView: UIView {
    
    @IBOutlet weak var typeWithAction: TypeWithAction!
    @IBOutlet weak var typeWithMessage: TypeWithMessage!
    @IBOutlet weak var typeWithActivity: TypeWithActivity!
    
    internal var blackLayer = CALayer()
        
    override func awakeFromNib() {
        self.blackLayer.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5).cgColor
    }

    internal func show(withMessage message: String, success: Bool, code: Int = 422) {
        if !self.typeWithAction.isHidden { return }
        self.backgroundColor = .white
        self.typeWithAction.isHidden = false
        self.typeWithMessage.isHidden = true
        self.typeWithActivity.isHidden = true
        self.typeWithAction.activityLabel.text = message
        
        if success {
        self.typeWithAction.activityImageView.image = #imageLiteral(resourceName: "activity_success")
        } else {
            self.typeWithAction.activityImageView.image = #imageLiteral(resourceName: "activity_error")
        }
        
        self.bringSubviewToFront(self.typeWithAction)
        self.showApply()
    }
    
    internal func show(withMessage message: String) {
        if !self.typeWithAction.isHidden { return }
        self.backgroundColor = .white
        self.typeWithAction.isHidden = true
        self.typeWithMessage.isHidden = false
        self.typeWithActivity.isHidden = true
        self.typeWithMessage.activityLabel.text = message
        self.typeWithMessage.activity.color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        self.typeWithMessage.activity.startAnimating()
        self.bringSubviewToFront(self.typeWithMessage)
        self.showApply()
    }
    
    internal func show() {
        if !self.typeWithAction.isHidden || self.isShowing() { return }
        self.backgroundColor = .clear
        self.typeWithAction.isHidden = true
        self.typeWithMessage.isHidden = true
        self.typeWithActivity.isHidden = false
        self.typeWithActivity.activity.color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        self.typeWithActivity.activity.startAnimating()
        self.bringSubviewToFront(self.typeWithActivity)
        self.showApply()
    }
    
    internal func hide() {
        if !self.isShowing() || self.cantHide() { return }
        self.typeWithMessage.activity.stopAnimating()
        self.typeWithActivity.activity.stopAnimating()
        self.removeFromSuperview()
        self.blackLayer.removeFromSuperlayer()
        self.endIgnoring()
    }
    
    internal func hideWithoutMessage() {
        self.endIgnoring()
        self.typeWithAction.activityAction(sender: self.typeWithAction.activityButton)
    }
    
    internal func cantHide() -> Bool {
        return (self.typeWithMessage.activity.isAnimating || !self.typeWithAction.isHidden)
    }
    
    internal func isShowing() -> Bool {
        return (self.typeWithMessage.activity.isAnimating || self.typeWithActivity.activity.isAnimating)
    }
    
    private func showApply() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        
        self.blackLayer.frame = window?.frame ?? .zero
        window?.layer.addSublayer(self.blackLayer)
        
        self.center = window?.center ?? .zero
        window?.addSubview(self)
        
        (!self.typeWithAction.isHidden) ? self.endIgnoring() : self.beginIgnoring()
    }

    private func beginIgnoring() {
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    private func endIgnoring() {
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}
