//
//  RecommendationViewModel.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

protocol ProfileDelegate: class {
    func context()
}

class ProfileViewModel {
    
    fileprivate weak var vc: ProfileDelegate? = nil
    
    internal func setView(_ vc: ProfileDelegate) {
        self.vc = vc
    }
    
    internal func user() {
        print("call user service")
        self.vc?.context()
    }
    
}
