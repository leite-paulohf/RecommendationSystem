//
//  TypeWithAction.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 13/06/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import UIKit

class TypeWithAction: UIView {
    
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityButton: UIButton!
    
    override func awakeFromNib() {
        self.isHidden = true
        self.backgroundColor = .white
    }
    
    @IBAction func activityAction(sender: UIButton) {
        self.isHidden = true        
        if let activityIndicatorView = self.superview as? ActivityIndicatorView {
            activityIndicatorView.typeWithMessage.activity.stopAnimating()
            activityIndicatorView.typeWithActivity.activity.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            activityIndicatorView.blackLayer.removeFromSuperlayer()
        }
    }
    
}
