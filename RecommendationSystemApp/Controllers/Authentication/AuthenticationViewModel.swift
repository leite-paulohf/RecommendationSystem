//
//  AuthenticationViewModel.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

protocol AuthenticationDelegate: class {
    func context()
}

class AuthenticationViewModel {

    fileprivate weak var vc: AuthenticationDelegate? = nil
    
    internal func setView(_ vc: AuthenticationDelegate) {
        self.vc = vc
    }
    
    internal func search() {
        print("call search service")
        self.vc?.context()
    }

    internal func login() {
        print("call login service")
        self.vc?.context()
    }

    internal func register() {
        print("call register service")
        self.vc?.context()
    }

}
