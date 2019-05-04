//
//  RecommendationVC.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

class RecommendationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    internal lazy var viewModel: RecommendationViewModel = {
        let vm = RecommendationViewModel()
        vm.setView(self)
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - RestaurantDelegate

extension RecommendationVC: RecommendationDelegate {
    
    func context() {
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension RecommendationVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let alpha = CGFloat.random(in: 0.1...1)
        cell.backgroundColor = UIColor.blue.withAlphaComponent(alpha)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension RecommendationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
