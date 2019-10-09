//
//  UIDeviceExtension.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 20/10/16.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        case phone
        case pad
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct Is {
        static let iPhone4          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let iPhone5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let iPhone6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let iPhone6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let iPad             = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }
    
    var iOS: Double? {
        if UIDevice.current.systemName == "iOS" {
            if let iosVersion = Double(UIDevice.current.systemVersion) {
                return iosVersion
            }
        }
        return nil
    }

    var bundleShortVersionString: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var bundleVersionString: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    var environment: [String : Any]? {
        return Bundle.main.infoDictionary?["LSEnvironment"] as? [String : Any]
    }

}
