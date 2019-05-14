//
//  UserService.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 12/05/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import Foundation

class UserService: NetworkBaseService {
    
    static let shared = UserService()
    
    typealias UserHandler = (NetworkResult<User, NetworkError, Int>) -> Void
    
    // MARK: - Endpoints
    
    internal func getUser(id: String, handler: @escaping UserHandler) {
        let path = "user/\(id)"
        let service = NetworkService(api: .local, path: path)
        NetworkDispatch.shared.get(service: service, key: "data") {
            handler($0)
        }
    }
    
}
