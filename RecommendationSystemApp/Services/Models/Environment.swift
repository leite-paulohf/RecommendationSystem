//
//  Environment.swift
//  RSystemApp
//
//  Created by Thiago Holanda on 8/11/16.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import Foundation
import ObjectMapper

class HostsObject: Mappable {
    
    var local: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.local <- map["Local"]
    }
}

class EnvironmentUtil {
    
    fileprivate static var environment: [String : Any] {
        return UIDevice.current.environment ?? [:]
    }
    
    static var hosts: HostsObject? {
        let JSON = self.environment["Hosts"] as? [String : Any] ?? [:]
        return HostsObject(JSON: JSON)
    }
    
}
