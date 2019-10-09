//
//  RecommendationViewModel.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

protocol RecommendationDelegate: class {
    func context()
}

class RecommendationViewModel {
    
    fileprivate weak var vc: RecommendationDelegate? = nil
    
    internal func setView(_ vc: RecommendationDelegate) {
        self.vc = vc
    }
    
    internal func recommendations() {
        print("call recommendation service")
        self.vc?.context()
    }
    
}
