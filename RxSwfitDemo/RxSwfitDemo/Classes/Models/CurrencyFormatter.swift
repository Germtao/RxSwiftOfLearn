//
//  CurrencyFormatter.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation

/// 货币格式化器
enum CurrencyFormatter {
    static let dollarsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
}

extension NumberFormatter {
    // 避免每次都必须将浮点数强制转换为NSNumbers的便捷方法
    func string(from float: Float) -> String? {
        return string(from: NSNumber(value: float))
    }
}
