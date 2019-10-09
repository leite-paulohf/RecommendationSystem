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
            case .failure(let error, let code):
                if code == 404 {
                    let controller: RegisterVC? = self.vc?.navigation()?.push(.authentication)
                    controller?.id = id
                } else {
                    self.vc?.showError(message: error.message())
                }
            }
        }
    }

    internal func register(cuisine: Int, discount: Int, time: Int, price: Int, moment: Int, id: Int) {
        
    }
    
}

extension StringProtocol {
    var isValidCPF: Bool {
        let numbers = compactMap({ Int(String($0)) })
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = slice.count + 2
            let digit = 11 - slice.reduce(into: 0) {
                number -= 1
                $0 += $1 * number
                } % 11
            return digit > 9 ? 0 : digit
        }
        let dv1 = digitCalculator(numbers.prefix(9))
        let dv2 = digitCalculator(numbers.prefix(10))
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
}
