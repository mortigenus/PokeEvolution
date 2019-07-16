//
//  AppEnvironment.swift
//  PokeEvolution
//
//  Created by Ivan Chalov on 16/07/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
//

import Foundation

struct Environment {
    let apiClient = APIClient()
}

struct AppEnvironment {
    fileprivate static var stack: [Environment] = [Environment()]

    public static var current: Environment! {
        return stack.last
    }
    public static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    @discardableResult
    public static func popEnvironment() -> Environment? {
        return stack.popLast()
    }
    public static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
}
