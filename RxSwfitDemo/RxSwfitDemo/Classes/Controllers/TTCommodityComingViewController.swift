//
//  TTCommodityComingViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/11.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class TTCommodityComingViewController: UIViewController {
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var creditCardIcon: UIImageView!
    
    var cardType: TTCardType = .unknown {
        didSet {
            configureIconForCardType()
        }
    }
}

extension TTCommodityComingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "付款成功"
        
        configureIconForCardType()
        configureLabelsFromCart()
    }
}

private extension TTCommodityComingViewController {
    func configureIconForCardType() {
        guard let iconView = creditCardIcon else { return }
        iconView.image = cardType.image
    }
    
    func configureLabelsFromCart() {
        let cart = TTShoppingCart.shared
        costLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
        orderLabel.text = cart.itemCountStr
    }
}
