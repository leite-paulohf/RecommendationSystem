//
//  User.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 03/04/2018.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    static let shared = User()
    var id: Int?
    
    init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        self.id <- map["user_id"]
    }

    func logged() -> Bool {
        return self.id != nil
    }

    func logout() {
        self.id = nil
    }

}
