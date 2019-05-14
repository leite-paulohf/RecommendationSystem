//
//  AuthenticationViewModel.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

protocol AuthenticationDelegate: class, Helper {
    func context()
}

class AuthenticationViewModel {

    fileprivate weak var vc: AuthenticationDelegate? = nil
    
    internal func setView(_ vc: AuthenticationDelegate) {
        self.vc = vc
    }
    
    internal func authentication(id: String) {
        UserService.shared.getUser(id: id) { (response) in
            switch response {
            case .success(let user, _):
                User.shared.id = user.id
                self.vc?.context()
            case .failure(let error, _):
                
                self.vc?.showError(message: error.message())
            }
        }
    }

    internal func register() {
        print("call register service")
        self.vc?.context()
    }
    
}
