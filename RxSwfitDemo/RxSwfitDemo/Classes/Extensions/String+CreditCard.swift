//
//  String+CreditCard.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation

extension String {
    /// 移除空格
    var removingSpaces: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    /// 全为数字
    var areAllCharactersNumbers: Bool {
        let nonNumberCharacterSet = CharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: nonNumberCharacterSet) == nil
    }
    
    /// 整数值
    func integerValue(ofFirstCharacters count: Int) -> Int? {
        guard areAllCharactersNumbers, count <= self.count else {
            return nil
        }
        
        let substring = prefix(count)
        guard let integerValue = Int(substring) else { return nil }
        
        return integerValue
    }
    
    /// 是否有效
    var isValid: Bool {
        guard areAllCharactersNumbers else { return false }
        
        let reversed = self.reversed().map { String($0) }
        
        var sum: Int = 0
        for (index, element) in reversed.enumerated() {
            guard let digit = Int(element) else { return false }
            
            if index % 2 == 1 {
                switch digit {
                case 9:
                    sum += 9
                default:
                    // 乘以2，然后将除以9的余数得到数字的加法
                    sum += ((digit * 2) % 9)
                }
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}
