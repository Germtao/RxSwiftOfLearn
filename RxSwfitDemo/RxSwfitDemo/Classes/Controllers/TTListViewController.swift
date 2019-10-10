//
//  TTListViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class TTListViewController: UIViewController {
    
    @IBOutlet weak var cardItem: UIBarButtonItem!
    @IBOutlet weak var listView: UITableView!
    let europeanCommodities = Commodity.ofEurope
}

extension TTListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "商品列表"
        
        listView.delegate = self
        listView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCardItem()
    }
}

extension TTListViewController {
    func updateCardItem() {
        cardItem.title = "\(TTShoppingCart.shared.commodities.count)🍫"
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
        TTShoppingCart.shared.commodities.append(commodity)
        updateCardItem()
    }
}
