//
//  Commodity.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation

struct Commodity: Equatable, Hashable {
    let priceInDollars: Float
    let countryName: String
    let countryFlagEmoji: String
    
    // 一系列来自欧洲的巧克力
    static let ofEurope: [Commodity] = {
        let belgian = Commodity(priceInDollars: 8.0,
                                countryName: "比利时",
                                countryFlagEmoji: "🇧🇪")
        let british = Commodity(priceInDollars: 7.0,
                                countryName: "英国",
                                countryFlagEmoji: "🇬🇧")
        let dutch = Commodity(priceInDollars: 8.0,
                              countryName: "荷兰",
                              countryFlagEmoji: "🇳🇱")
        let german = Commodity(priceInDollars: 7.0,
                               countryName: "德国",
                               countryFlagEmoji: "🇩🇪")
        let swiss = Commodity(priceInDollars: 9.0,
                              countryName: "瑞士",
                              countryFlagEmoji: "🇨🇭")
        return [belgian, british, dutch, german, swiss]
    }()
}
