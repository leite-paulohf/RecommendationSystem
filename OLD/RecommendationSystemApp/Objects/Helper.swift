//
//  Helper.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 04/09/2018.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

protocol Helper {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showMessage(title: String, message: String)
    func showMessage(title: String, message: String, actions: [UIAlertAction])
    func navigation() -> UINavigationController?
}

extension Helper where Self: UIViewController {
    
    func showLoading() {
        NVActivityIndicatorView.activity.show()
    }
    
    func hideLoading() {
        NVActivityIndicatorView.activity.hide()
    }
    
    func showError(message: String) {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        self.showMessage(title: "RSystemApp", message: message, actions: [okAction])
    }
    
    func showMessage(title: String, message: String) {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        self.showMessage(title: title, message: message, actions: [okAction])
    }
    
    func showMessage(title: String, message: String, actions: [UIAlertAction]) {
        NVActivityIndicatorView.activity.hide()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigation() -> UINavigationController? {
        return self.navigationController
    }
    
}
