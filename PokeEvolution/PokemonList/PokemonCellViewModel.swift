//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import Foundation

protocol PokemonCellViewModelDelegate: class {
    func didFinishLoadingInfo(_ viewModel: PokemonCellViewModel)
}

class PokemonCellViewModel {
    let name: String
    var varieties: String?
    var habitat: String?
    var shape: String?

    weak var delegate: PokemonCellViewModelDelegate?

    private var operation: Operation?
    private let pokemon: NamedAPIResource

    init(pokemon: NamedAPIResource) {
        self.name = pokemon.name
        self.pokemon = pokemon
    }

    func start() {
        self.operation = AppEnvironment.current.apiClient.fetchPokemonInfo(pokemon) { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .success(let response):
                self.varieties = "varieties: \(response.varieties.map({ $0.pokemon.name }).joined(separator: ", "))"
                self.habitat = "habitat: \(response.habitat.name)"
                self.shape = "shape: \(response.shape.name)"
            case .failure:
                //TODO error handling
                break
            }
            self.delegate?.didFinishLoadingInfo(self)
        }
    }

    func cancel() {
        operation?.cancel()
        self.operation = nil
    }
}
