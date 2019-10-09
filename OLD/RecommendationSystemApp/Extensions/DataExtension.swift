//
//  DataExtension.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 27/10/16.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import Foundation

extension Data {
    
    @nonobjc var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
    
    internal func modelObject() -> [String : Any]? {
        do {
            let model = try JSONSerialization.jsonObject(with: self, options: []) as? [String : Any]
            return model
        } catch {
            Log.shared.show(error: error.localizedDescription)
            return [String : Any]()
        }
    }

    internal func modelArray() -> [[String : Any]]? {
        do {
            let model = try JSONSerialization.jsonObject(with: self, options: []) as? [[String : Any]]
            return model
        } catch {
            Log.shared.show(error: error.localizedDescription)
            return [[String : Any]]()
        }
    }

    internal func modelObject(key: String) -> [String : Any]? {
        let model = self.modelObject() ?? [:]
        return model[key] as? [String : Any]
    }

    internal func modelArray(key: String) -> [[String : Any]]? {
        let model = self.modelObject() ?? [:]
        return model[key] as? [[String : Any]]
    }

}
