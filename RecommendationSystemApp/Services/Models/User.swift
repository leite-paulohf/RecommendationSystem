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
    var error: String?
    
    init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        self.id <- map["user_id"]
        self.error <- map["error"]
    }

    func logged() -> Bool {
        return self.id != nil
    }

    func logout() {
        self.id = nil
        self.error = nil
    }

}
