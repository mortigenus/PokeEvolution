//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import UIKit

class EvolutionPokemonListViewModel: NSObject, PokemonListViewModel {
    let title: String

    weak var delegate: PokemonListViewModelDelegate?
    private let pokemon: NamedAPIResource
    private var evolutionChain: EvolutionChain?
    private var selectedEvolutionChain: EvolutionChain?

    init(pokemon: NamedAPIResource, evolutionChain: EvolutionChain? = nil) {
        self.pokemon = pokemon
        self.evolutionChain = evolutionChain

        self.title = self.pokemon.name
    }

    func viewDidLoad() {
        loadEvolutionChain()
    }

    func reloadRequested() {
        loadEvolutionChain(force: true)
    }

    private func loadEvolutionChain(force: Bool = false) {
        AppEnvironment.current.apiClient.fetchPokemonInfo(pokemon, force: force) { [weak self] result in
            if case .success(let response) = result {
                AppEnvironment.current.apiClient.fetchEvolutionChain(response.evolutionChain, force: force) { [weak self] result in
                    guard let `self` = self else {
                        return
                    }
                    switch result {
                    case .success(let response):
                        // evolution chain API returns the chain from the start,
                        // so we need to find the current pokémon's place in it
                        self.evolutionChain = self.find(self.pokemon, in: response.chain)
                    case .failure:
                        break
                    }
                    self.delegate?.didFinishLoadingPokemonList(self)
                }
            }
        }
    }

    private func find(_ pokemon: NamedAPIResource, in chain: EvolutionChain) -> EvolutionChain? {
        if chain.species == pokemon && chain.canEvolve {
            return chain
        }
        return chain.evolvesTo.first(where: { find(pokemon, in: $0) != nil })
    }

    func evolutionViewModelForSelectedPokemon() -> PokemonListViewModel? {
        guard let chain = selectedEvolutionChain else {
            return nil
        }
        guard chain.canEvolve else {
            return nil
        }
        return EvolutionPokemonListViewModel(pokemon: chain.species, evolutionChain: chain)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evolutionChain?.evolvesTo.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PokemonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let chain = evolutionChain!.evolvesTo[indexPath.row]
        let viewModel = PokemonCellViewModel(pokemon: chain.species)
        cell.viewModel = viewModel
        cell.accessoryType = chain.canEvolve ? .disclosureIndicator : .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! PokemonCell).viewModel.start()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chain = evolutionChain!.evolvesTo[indexPath.row]
        self.selectedEvolutionChain = chain
        self.delegate?.didSelectPokemon(self)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let chain = evolutionChain!.evolvesTo[indexPath.row]
        return chain.canEvolve
    }
}
