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
    @IBOutlet weak var cpfTextField: UITextField!
    @IBOutlet weak var cuisinePicker: UIPickerView!
    @IBOutlet weak var discountPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var momentPicker: UIPickerView!
    @IBOutlet weak var registerButton: UIButton!
    
    fileprivate var cuisine: [(String, Int)] = [("Alemã",1),
                                                ("Contemporânea",13),
                                                ("Mineira",25),
                                                ("AlmoçoExpress",2),
                                                ("Creperia",14),
                                                ("Peruana",26),
                                                ("Americana",3),
                                                ("Espanhola",15),
                                                ("Pizzaria",27),
                                                ("Árabe",4),
                                                ("Francesa",16),
                                                ("Portuguesa",28),
                                                ("Asiática",5),
                                                ("FrutosdoMar",17),
                                                ("Saudável",29),
                                                ("Australiana",6),
                                                ("Hamburgueria",18),
                                                ("Sorveteria",30),
                                                ("Brasileira",7),
                                                ("Indiana",19),
                                                ("Tailandesa",31),
                                                ("Cafeteria",8),
                                                ("Internacional",20),
                                                ("Torta",32),
                                                ("Carnes",9),
                                                ("Italiana",21),
                                                ("Turca",33),
                                                ("Chinesa",10),
                                                ("Japonesa",22),
                                                ("Variada",34),
                                                ("ComidadeBoteco",11),
                                                ("Mediterrânea",23),
                                                ("Vegetariana",35),
                                                ("ComidaRápida",12),
                                                ("Mexicana",24)]
    
    fileprivate var discount: [(String, Int)] = [("Gosto muito", 50),
                                                 ("As vezes é bom", 30),
                                                 ("Não me importo", 20)]

    fileprivate var time: [(String, Int)] = [("No horário do almoço", 3),
                                             ("Pela tarde", 1),
                                             ("Na horário do jantar", 2),
                                             ("Na madrugada", 4)]
    
    fileprivate var price: [String] = ["No máximo R$25",
                                       "No máximo R$50",
                                       "No máximo R$75",
                                       "No máximo R$100",
                                       "Mais de R$100"]

    fileprivate var moment: [String] = ["Família",
                                        "Amigos",
                                        "Em casal",
                                        "Indiferente"]

    fileprivate var selectedCuisine: (String, Int)? = nil
    fileprivate var selectedDiscount: (String, Int)? = nil
    fileprivate var selectedTime: (String, Int)? = nil
    fileprivate var selectedPrice: (String, Int)? = nil
    fileprivate var selectedMoment: (String, Int)? = nil
    
    internal var id: String? = nil

    internal lazy var viewModel: AuthenticationViewModel = {
        let vm = AuthenticationViewModel()
        vm.setView(self)
        return vm
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cpfTextField.text = self.id
        self.cuisinePicker.delegate = self
        self.discountPicker.delegate = self
        self.timePicker.delegate = self
        self.pricePicker.delegate = self
        self.momentPicker.delegate = self
        self.cuisinePicker.dataSource = self
        self.discountPicker.dataSource = self
        self.timePicker.dataSource = self
        self.pricePicker.dataSource = self
        self.momentPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        if let cuisine = self.selectedCuisine,
            let discount = self.selectedDiscount,
            let time = self.selectedTime,
            let price = self.selectedPrice,
            let moment = self.selectedMoment,
            let id = self.cpfTextField.text, !id.isEmpty, id.isValidCPF {
//            self.viewModel.register(cuisine: <#T##Int#>, discount: <#T##Int#>, time: <#T##Int#>, price: <#T##Int#>, moment: <#T##Int#>, id: <#T##Int#>)
        } else {
            self.showError(message: "Responda todas as perguntas para continuar")
        }
    }

}

extension RegisterVC: AuthenticationDelegate {
    
    func context() {
        self.navigationController?.setRoot(.main)
    }
    
}

extension RegisterVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        if pickerView == self.cuisinePicker {
            self.selectedCuisine = self.cuisine[row]
        } else if pickerView == self.discountPicker {
            self.selectedDiscount = self.discount[row]
        } else if pickerView == self.timePicker {
            self.selectedTime = self.time[row]
        } else if pickerView == self.pricePicker {
            self.selectedPrice = self.price[row]
        } else if pickerView == self.momentPicker {
            self.selectedMoment = self.moment[row]
        }
    }
    
}

extension RegisterVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.cuisinePicker {
            return self.cuisine.count
        } else if pickerView == self.discountPicker {
            return self.discount.count
        } else if pickerView == self.timePicker {
            return self.time.count
        } else if pickerView == self.pricePicker {
            return self.price.count
        } else if pickerView == self.momentPicker {
            return self.moment.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let selected = row == pickerView.selectedRow(inComponent: component)
        label.textColor = selected ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 0.3254901961, green: 0.337254902, blue: 0.3529411765, alpha: 1)
        label.textAlignment = .center
        
        if pickerView == self.cuisinePicker {
            label.text = self.cuisine[row].0
        } else if pickerView == self.discountPicker {
            label.text = self.discount[row].0
        } else if pickerView == self.timePicker {
            label.text = self.time[row].0
        } else if pickerView == self.pricePicker {
            label.text = self.price[row].0
        } else if pickerView == self.momentPicker {
            label.text = self.moment[row].0
        } else {
            label.text = nil
        }
        
        return label
    }
    
}


