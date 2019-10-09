//
//  SearchVC.swift
//  RecommendationSystemApp
//
//  Created by Paulo Henrique Leite on 20/03/19.
//  Copyright © 2019 leite.paulohf. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    internal lazy var viewModel: SearchViewModel = {
        let vm = SearchViewModel()
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

extension SearchVC: SearchDelegate {
    
    func context() {
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.restaurants().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RestaurantsCell()
        let restaurants = self.viewModel.restaurants()
        cell.configure(restaurants)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
