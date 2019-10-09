//
//  Helper.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 11/04/2018.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import Foundation
import UIKit

class Navigator {
    
    static let shared = Navigator()
        
    internal var visibleVC: UIViewController? {
        get {
            guard let window = UIApplication.shared.delegate?.window,
                let rootVC = window?.rootViewController else {
                return nil
            }

            switch rootVC {
            case is UINavigationController:
                let navigation = rootVC as? UINavigationController
                return navigation?.visibleViewController
            case is UITabBarController:
                let tabBar = rootVC as? UITabBarController
                let navigation = tabBar?.selectedViewController as? UINavigationController
                return navigation?.visibleViewController
            default:
                return nil
            }
        }
    }

    internal var tabBar: UITabBarController? {
        get {
            guard let window = UIApplication.shared.delegate?.window,
                let rootVC = window?.rootViewController else {
                    return nil
            }
            
            switch rootVC {
            case is UITabBarController:
                let tabBar = rootVC as? UITabBarController
                return tabBar
            default:
                return nil
            }
        }
    }

    internal var navigation: UINavigationController? {
        get {
            return self.visibleVC?.navigationController
        }
    }
    
    internal func navigation(tab: TabbarType) -> UINavigationController? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        guard let controller = delegate.window?.rootViewController as? RSystemAppTabBarVC else {
            return nil
        }
        
        guard let navigations = controller.viewControllers as? [UINavigationController] else {
            return nil
        }
        
        guard navigations.indices.contains(tab.index) else {
            return nil
        }
        
        return navigations[tab.index]
    }
    
    internal func choose(tab: TabbarType) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let controller = delegate.window?.rootViewController as? RSystemAppTabBarVC else {
            return
        }

        guard let items = controller.tabBar.items, items.indices.contains(tab.index) else {
            return
        }
        
        controller.selectedIndex = tab.index
    }

    internal func enabled(_ isEnabled: Bool, tab: TabbarType) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let controller = appDelegate.window?.rootViewController as? RSystemAppTabBarVC else {
            return
        }
        
        guard let items = controller.tabBar.items, items.indices.contains(tab.index) else {
            return
        }
        
        controller.tabBar.items?[tab.index].isEnabled = isEnabled
    }
    
    internal func dequeue<T>() -> T? where T: UIViewController {
        if let navigation = self.navigation(tab: .home),
            let controller = navigation.viewControllers.first(where: { $0 is T }) as? T {
            return controller
        }
        
        if let navigation = self.navigation(tab: .search),
            let controller = navigation.viewControllers.first(where: { $0 is T }) as? T {
            return controller
        }

        if let navigation = self.navigation(tab: .validations),
            let controller = navigation.viewControllers.first(where: { $0 is T }) as? T {
            return controller
        }

        if let navigation = self.navigation(tab: .profile),
            let controller = navigation.viewControllers.first(where: { $0 is T }) as? T {
            return controller
        }
        
        return nil
    }

    internal func updateProfileTab() {
        guard let navigation = self.navigation(tab: .profile),
            navigation.viewControllers.indices.contains(0) else {
                return
        }
        
        if User.shared.logged() {
            let controller: ProfileVC = navigation.load(.profile)
            navigation.viewControllers[0] = controller
            self.enabled(true, tab: .validations)
        } else {
            let controller: AuthenticationVC = navigation.load(.authentication)
            navigation.viewControllers[0] = controller
            self.enabled(false, tab: .validations)
        }
    }

}
