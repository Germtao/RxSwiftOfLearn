//
//  TTListViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TTListViewController: UIViewController {
    
    @IBOutlet weak var cardItem: UIBarButtonItem!
    @IBOutlet weak var listView: UITableView!
    let europeanCommodities = Commodity.ofEurope
    
    private let disposeBag = DisposeBag()
}

extension TTListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "商品列表"
        
        listView.delegate = self
        listView.dataSource = self
        
        setupCartObserver()
    }
}

// MARK: - Rx Setup
extension TTListViewController {
    func setupCartObserver() {
        // 1.
        TTShoppingCart.shared.commodities.asObservable()
            .subscribe(onNext: { // 2.
                [unowned self] commondites in
                self.cardItem.title = "\(commondites.count)🍫"
            }) // 3.
            .disposed(by: disposeBag)
    }
}

extension TTListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return europeanCommodities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TTListViewCell.reuseIdentifier,
                                                       for: indexPath) as? TTListViewCell else {
            return UITableViewCell()
        }
        let commodity = europeanCommodities[indexPath.row]
        cell.configure(with: commodity)
        return cell
    }
}

extension TTListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let commodity = europeanCommodities[indexPath.row]
        let newValue = TTShoppingCart.shared.commodities.value + [commodity]
        TTShoppingCart.shared.commodities.accept(newValue)
    }
}
