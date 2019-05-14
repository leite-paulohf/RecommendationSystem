//
//  ValidationService.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 26/07/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import Foundation

class UsageService: NetworkBaseService {
    
    static let shared = UsageService()
    
    typealias RestaurantHandler = (NetworkResult<Restaurant, NetworkError, Int>) -> Void
    
    // MARK: - Endpoints

    internal func getRestaurants(uuid: String, handler: @escaping RestaurantHandler) {
        let path = "restaurants/\(uuid)/slots/seats"
        let service = NetworkService(api: .local, path: path)
        NetworkDispatch.shared.get(service: service, key: "data") {
            handler($0)
        }
    }

}
