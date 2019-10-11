//
//  String+ExpirationDate.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation

extension String {
    var addingSlash: String {
        guard count > 2 else { return self }
        
        let index2 = index(startIndex, offsetBy: 2)
        let firstTwo = prefix(upTo: index2)
        let rest = suffix(from: index2)
        
        return firstTwo + " / " + rest
    }
    
    var removingSlash: String {
        return replacingOccurrences(of: " / ", with: "")
    }
    
    var isExpirationDateValid: Bool {
        let noSlash = removingSlash
        
        // mmyyyy
        guard noSlash.count == 6 &&
            noSlash.areAllCharactersNumbers else { return false }
        
        let index2 = index(startIndex, offsetBy: 2)
        let monthString = prefix(upTo: index2)
        let yearString = suffix(from: index2)
        
        guard let month = Int(monthString),
            let year = Int(yearString) else { return false }
        
        guard month >= 1 && month <= 12 else { return false }
        
        let now = Date()
        let currentYear = now.year
        
        guard year >= currentYear else { return false }
        
        if year == currentYear {
            let currentMonth = now.month
            guard month >= currentMonth else { return false }
        }
        
        return true
    }
}
