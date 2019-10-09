//
//  RSystemAppTabBarVC.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 03/04/2018.
//  Modified by Paulo Henrique Leite on 01/02/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import UIKit

class RSystemAppTabBarVC: UITabBarController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
