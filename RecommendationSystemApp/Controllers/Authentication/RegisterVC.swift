//
//  RegisterVC.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cpfTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
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
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        self.viewModel.register()
    }

}

extension RegisterVC: AuthenticationDelegate {
    
    func context() {
        self.navigationController?.setRoot(.main)
    }
    
}
