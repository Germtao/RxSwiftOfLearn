//
//  Issue.swift
//  RxMoyaExample
//
//  Created by QDSG on 2019/10/12.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Mapper

struct Issue: Mappable {
    let identifier: String
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
