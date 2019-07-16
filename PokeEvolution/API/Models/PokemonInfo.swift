//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import Foundation

struct PokemonVariety: Decodable {
    let pokemon: NamedAPIResource
}

struct PokemonInfo: Decodable {
    let name: String
    let evolutionChain: APIResource
    let varieties: [PokemonVariety]
    let habitat: NamedAPIResource
    let shape: NamedAPIResource
}
