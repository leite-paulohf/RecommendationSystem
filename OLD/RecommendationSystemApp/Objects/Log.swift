//
//  Log.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 22/12/2017.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import UIKit

class Log {

    static let shared = Log()

    internal func show(info: Any) {
        print("💚 \(info)")
    }

    internal func show(error: Any) {
        print("❤️ \(error)")
    }

    internal func show(event: Any) {
        #if DEBUG
            print("💙 \(event)")
        #endif
    }
    
    internal func show(realm: Any) {
        #if DEBUG
            print("🖤 \(realm)")
        #endif
    }

}
