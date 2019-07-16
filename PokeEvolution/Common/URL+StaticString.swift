//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL: \(string)")
        }

        self = url
    }
}
