//
//  RecommendationViewModel.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func context()
}

class SearchViewModel {
    
    fileprivate weak var vc: SearchDelegate? = nil
    
    internal func setView(_ vc: SearchDelegate) {
        self.vc = vc
    }
    
    internal func restaurants() {
        print("call restaurants service")
        self.vc?.context()
    }
    
}
