//
//  PokemonURLBuilder.swift
//  PokeEvolution
//
//  Created by Ivan Chalov on 16/07/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
//

import Foundation

struct PokemonURLBuilder {
    let baseURL: URL
    private let pokemonComponent = "pokemon-species"

    func pokemonListURL() -> URL {
        let url = baseURL.appendingPathComponent(pokemonComponent)
        var listURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        listURLComponents.queryItems = [
            URLQueryItem(name: "limit", value: "-1"),
            URLQueryItem(name: "offset", value: "0")
        ]
        return listURLComponents.url!
    }
}
