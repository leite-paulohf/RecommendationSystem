//
//  UIViewControllerExtension.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 18/04/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import UIKit
import ObjectiveC

private var scrollViewKey: UInt8 = 0
private var indexKey: UInt8 = 0

extension UIView {
    
    @nonobjc class func instanceFromNib() -> UIView {
        let nib = UINib(nibName: "\(self)", bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        let view = views.first as? UIView
        return view ?? UIView()
    }

}

extension UIViewController {

    @nonobjc private weak var scrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &scrollViewKey) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &scrollViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    @nonobjc internal var index: Int? {
        get {
            return objc_getAssociatedObject(self, &indexKey) as? Int
        }
        set(newValue) {
            objc_setAssociatedObject(self, &indexKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    func hideNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func hideKeyboardWhenTappedAround() {
        let action = #selector(self.hideKeyboard)
        let tap = UITapGestureRecognizer(target: self, action: action)
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

    func addKeyboardObserver(scrollView: UIScrollView) {
        self.scrollView = scrollView
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        self.scrollView = nil
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
        var keyboardFrame = (value as? NSValue)?.cgRectValue ?? CGRect()
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset = self.scrollView?.contentInset ?? UIEdgeInsets()
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView?.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView?.contentInset ?? UIEdgeInsets()
        contentInset.bottom = 0
        self.scrollView?.contentInset = contentInset
    }

}

