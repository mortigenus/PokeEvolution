//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import Foundation

struct APIResource: Decodable, Equatable {
    let url: URL
}

struct NamedAPIResource: Decodable, Equatable {
    let name: String
    let url: URL
}
