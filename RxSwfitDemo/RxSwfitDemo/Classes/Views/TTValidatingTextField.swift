//
//  TTValidatingTextField.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class TTValidatingTextField: UITextField {

    var valid: Bool = false {
        didSet {
           configureForValid()
        }
    }
    
    var hasBeenExited: Bool = false {
        didSet {
            configureForValid()
        }
    }
    
    override func resignFirstResponder() -> Bool {
        hasBeenExited = true
        return super.resignFirstResponder()
    }
}

extension TTValidatingTextField {
    private func configureForValid() {
        if !valid && hasBeenExited {
            backgroundColor = .red
        } else {
            backgroundColor = .clear
        }
    }
}
