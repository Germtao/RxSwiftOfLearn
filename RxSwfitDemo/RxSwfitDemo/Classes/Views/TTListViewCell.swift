//
//  TTListViewCell.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class TTListViewCell: UITableViewCell {
    
    static let reuseIdentifier = "listViewCellID"

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    func configure(with commodity: Commodity) {
        countryNameLabel.text = commodity.countryName
        emojiLabel.text = "🍫" + commodity.countryFlagEmoji
        priceLabel.text = CurrencyFormatter.dollarsFormatter.string(from: commodity.priceInDollars)
    }

}
