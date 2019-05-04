//
//  LoginVC.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    internal lazy var viewModel: AuthenticationViewModel = {
        let vm = AuthenticationViewModel()
        vm.setView(self)
        return vm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.viewModel.login()
    }
    
}

extension LoginVC: AuthenticationDelegate {
    
    func context() {
        self.navigationController?.setRoot(.main)
    }
    
}
