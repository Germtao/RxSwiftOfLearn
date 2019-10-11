//
//  TTSegueHandler.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/11.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

/*
Protocol to make sure all segues are handled safely. More on this techinque:
https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
*/
protocol TTSegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension TTSegueHandlerType // 默认实现
    where Self: UIViewController, // 用于视图控制器
    SegueIdentifier.RawValue == String { // 具有字符串segue标识符
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any? = nil) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func identifier(forSegue segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Invalid segue identifier \(segue.identifier ?? "")")
        }
        
        return segueIdentifier
    }
}
