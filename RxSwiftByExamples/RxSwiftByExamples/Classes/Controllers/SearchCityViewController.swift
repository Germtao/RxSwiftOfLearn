//
//  SearchCityViewController.swift
//  RxSwiftByExamples
//
//  Created by QDSG on 2019/10/11.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchCityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shownCities: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    let allCities = ["Shang Hai", "Bei Jing", "Xi An", "Hang Zhou", "Wu Han", "Cheng Du", "Nan Jing", "Nan Chang"]
    
    private let reuseIdentifier = "cityCellId"
    
    private let disposeBag = DisposeBag()
}

extension SearchCityViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        setupSearchBarHandler()
    }
}

// MARK: - Rx
extension SearchCityViewController {
    func setupSearchBarHandler() {
        searchBar
            .rx
            .text // RxCocoa可观察的属性
            .orEmpty // 使其为非可选
            .subscribe(onNext: { [unowned self] (query) in // 接收到每个新值的通知
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) }
            })
            .disposed(by: disposeBag)
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
