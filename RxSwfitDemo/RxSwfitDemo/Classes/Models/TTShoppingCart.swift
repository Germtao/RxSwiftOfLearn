//
//  TTShoppingCart.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class TTShoppingCart: NSObject {
    static let shared = TTShoppingCart()
    
    /// 商品数组
    var commodities: [Commodity] = []
}

// MARK: - 不可变
extension TTShoppingCart {
    /// 总花费
    var totalCost: Float {
        return commodities.reduce(0) { (runningTotal, commodity) in
            return runningTotal + commodity.priceInDollars
        }
    }
    
    var itemCountStr: String {
        guard commodities.count > 0 else {
            return "🚫🍫"
        }
        
        let setOfCommodities = Set<Commodity>(commodities)
        
        let itemStrings: [String] = setOfCommodities.map { (commodity) in
            let count: Int = commodities.reduce(0) { (runningTotal, reduceCommodity) in
                if commodity == reduceCommodity {
                    return runningTotal + 1
                }
                
                return runningTotal
            }
            
            return "\(commodity.countryFlagEmoji)🍫: \(count)"
        }
        
        return itemStrings.joined(separator: "\n")
    }
}
