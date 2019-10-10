//
//  TTCardViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class TTCardViewController: UIViewController {

    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!

}

extension TTCardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "购物车"
        configureFromCart()
    }
}

extension TTCardViewController {
    @IBAction func clearCard() {
        TTShoppingCart.shared.commodities = []
        navigationController?.popViewController(animated: true)
    }
}

extension TTCardViewController {
    func configureFromCart() {
        guard checkoutButton != nil else { return }
        
        let cart = TTShoppingCart.shared
        totalItemsLabel.text = cart.itemCountStr
        totalCostLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
        
        checkoutButton.isEnabled = cart.totalCost > 0
    }
}
