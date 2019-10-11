//
//  TTCartViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TTCartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!

    private let disposeBag = DisposeBag()
}

extension TTCartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "购物车"
        tableView.tableFooterView = UIView()
        configureFromCart()
        setupCellConfiguration()
    }
}

extension TTCartViewController {
    @IBAction func clearCard() {
        TTShoppingCart.shared.commodities.accept([])
        navigationController?.popViewController(animated: true)
    }
}

extension TTCartViewController {
    func configureFromCart() {
        guard checkoutButton != nil else { return }
        
        let cart = TTShoppingCart.shared
        totalItemsLabel.text = cart.itemCountStr
        totalCostLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
        
        checkoutButton.isEnabled = cart.totalCost > 0
    }
    
    func setupCellConfiguration() {
        let cart = TTShoppingCart.shared
        
        cart.commodities
            .bind(to: tableView
                .rx
                .items(cellIdentifier: TTListViewCell.reuseIdentifier, cellType: TTListViewCell.self)) {
                    (row, commodity, cell) in
                    cell.configure(with: commodity)
        }
        .disposed(by: disposeBag)
    }
}
