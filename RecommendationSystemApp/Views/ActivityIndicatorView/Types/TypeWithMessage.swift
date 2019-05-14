//
//  TypeWithMessage.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 13/06/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TypeWithMessage: UIView {
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLabel: UILabel!

    internal var activity: NVActivityIndicatorView!

    override func awakeFromNib() {
        self.isHidden = true
        self.backgroundColor = .white
        let size = self.activityView.frame.size
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.activity = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
        self.activityView.addSubview(activity)
    }    

}
