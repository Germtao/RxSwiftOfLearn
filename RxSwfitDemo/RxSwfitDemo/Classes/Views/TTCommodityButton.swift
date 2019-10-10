//
//  TTCommodityButton.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

@IBDesignable
class TTCommodityButton: UIButton {
    override var isEnabled: Bool {
        didSet {
           updateAlphaForEnabledState()
        }
    }
    
    enum TTButtonStyle {
        case standard, warning
    }
    
    /// 枚举值不进行IB检查的解决方法
    @IBInspectable var isStandard: Bool = false {
        didSet {
            style = isStandard ? .standard : .warning
        }
    }
    
    private var style: TTButtonStyle = .standard {
        didSet {
            updateBackgroundColorForCurrentType()
        }
    }
    
    private func commonInit() {
        setTitleColor(.white, for: .normal)
        updateBackgroundColorForCurrentType()
        updateAlphaForEnabledState()
    }
    
    func updateBackgroundColorForCurrentType() {
        switch style {
        case .standard:
            backgroundColor = UIColor(red: 62 / 255.0, green: 191 / 255.0, blue: 199 / 255.0, alpha: 1.0)
        case .warning:
            backgroundColor = .red
        }
    }
    
    func updateAlphaForEnabledState() {
        alpha = isEnabled ? 1.0 : 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
}
