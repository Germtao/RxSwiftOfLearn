//
//  CircleViewModel.swift
//  RxSwiftByExamples
//
//  Created by QDSG on 2019/10/12.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    var centerVariable: BehaviorRelay<CGPoint?> = BehaviorRelay(value: .zero)
    var backgroundColorObservale: Observable<UIColor>!
    
    init() {
        setup()
    }
    
    func setup() {
        backgroundColorObservale =
            centerVariable.asObservable().map { center in
                guard let center = center else { return UIColor.systemBackground }
                
                let red: CGFloat = 0.0
                let green: CGFloat = max(center.x, center.y).truncatingRemainder(dividingBy: 255.0) / 255.0
                let blue: CGFloat = max(center.x, center.y).truncatingRemainder(dividingBy: 255.0) / 255.0
                return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
