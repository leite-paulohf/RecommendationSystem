//
//  AuthenticationVC.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

class AuthenticationVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

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

    @IBAction func continueButtonAction(_ sender: UIButton) {
        if let id = dataTextField.text, !id.isEmpty, id.isValidCPF {
            self.viewModel.authentication(id: id)
        } else {
            self.showError(message: "Digite um CPF válido")
        }
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        self.navigationController?.setRoot(.main)
    }

}

extension AuthenticationVC: AuthenticationDelegate {
    
    func context() {
        self.navigationController?.setRoot(.main)
    }
    
}
