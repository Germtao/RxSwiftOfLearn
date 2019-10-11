//
//  SearchCityViewController.swift
//  RxSwiftByExamples
//
//  Created by QDSG on 2019/10/11.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shownCities: [String] = []
    let allCities = ["Shang Hai", "Bei Jing", "Xi An", "Hang Zhou", "Wu Han", "Cheng Du", "Nan Jing", "Nan Chang"]
    
    private let reuseIdentifier = "cityCellId"
}

extension SearchCityViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }
}

// MARK: - table view data source
extension SearchCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}
