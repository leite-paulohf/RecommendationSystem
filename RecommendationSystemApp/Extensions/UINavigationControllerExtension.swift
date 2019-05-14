//
//  UINavigationControllerExtension.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 10/11/16.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import UIKit

extension UINavigationController {

    internal func pop(completion: (() -> Void)? = nil) {
        self.popViewController(animated: true)
        completion?()
    }

    internal func pop(controller: UIViewController, completion: (() -> Void)? = nil) {
        self.popToViewController(controller, animated: true)
        completion?()
    }

    internal func root(completion: (() -> Void)? = nil) {
        self.popToRootViewController(animated: true)
        completion?()
    }

    internal func push(controller: UIViewController, completion: (() -> Void)? = nil) {
        self.pushViewController(controller, animated: true)
        completion?()
    }

    internal func dequeue<T>() -> T? where T: UIViewController {
        if let controller = self.viewControllers.first(where: { $0 is T }) as? T {
            return controller
        }

        return nil
    }

    internal func load<T>(_ name: Storyboard) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: name.rawValue.capitalized, bundle: nil)

        guard let controller = storyboard.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Could not instantiate view controller with identifier: \(T.identifier)")
        }

        return controller
    }

    internal func push<T>(_ name: Storyboard) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: name.rawValue.capitalized, bundle: nil)

        guard let controller = storyboard.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Could not instantiate view controller with identifier: \(T.identifier)")
        }

        self.push(controller: controller)

        return controller
    }

    internal func present<T>(_ name: Storyboard, modal: Bool = false) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: name.rawValue.capitalized, bundle: nil)

        guard let controller = storyboard.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Could not instantiate view controller with identifier: \(T.identifier)")
        }

        controller.modalPresentationStyle = .overFullScreen

        if modal {
            self.present(controller, animated: true, completion: nil)
        } else {
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        }

        return controller
    }

    internal func setRoot(_ name: Storyboard) {
        let storyboard = UIStoryboard(name: name.rawValue.capitalized, bundle: nil)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = storyboard.instantiateInitialViewController()
    }

    internal func setRootWithAnimation(_ name: Storyboard) {
        let storyboard = UIStoryboard(name: name.rawValue.capitalized, bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window ?? UIWindow()
        controller?.view.isHidden = true
        UIView.transition(with: window, duration: 1, options: .transitionFlipFromRight, animations: {
            window.rootViewController = controller
            controller?.view.isHidden = false
        }, completion: nil)
    }

}
