//
// Created by Ivan Chalov on 2019-07-17.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import Foundation

struct EvolutionChain: Decodable {
    let species: NamedAPIResource
    let evolvesTo: [EvolutionChain]

    var canEvolve: Bool {
        get {
            return !evolvesTo.isEmpty
        }
    }
}
