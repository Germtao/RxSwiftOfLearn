//
//  TTImageName.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

enum ImageName: String {
    case
    amex,
    discover,
    mastercard,
    visa,
    unkonwnCard
    
    var image: UIImage? {
        guard let image = UIImage(named: rawValue) else { return nil }
        return image
    }
}
