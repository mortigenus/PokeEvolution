//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import UIKit

class AllPokemonListViewModel: NSObject, PokemonListViewModel {
    let title: String = "Pokémon"

    weak var delegate: PokemonListViewModelDelegate?

    private var pokemonList = [NamedAPIResource]()
    private var selectedPokemon: NamedAPIResource?

    func viewDidLoad() {
        loadPokemon()
    }

    func reloadRequested() {
        loadPokemon(force: true)
    }

    private func loadPokemon(force: Bool = false) {
        AppEnvironment.current.apiClient.fetchPokemonList(force: force) { [weak self] result in
            guard let `self` = self else {
                return
            }

            switch result {
            case .success(let response):
                self.pokemonList = response.results
            case .failure:
                //TODO error handling
                break
            }
            self.delegate?.didFinishLoadingPokemonList(self)
        }
    }

    func evolutionViewModelForSelectedPokemon() -> PokemonListViewModel? {
        return selectedPokemon
                .flatMap { EvolutionPokemonListViewModel(pokemon: $0) }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UIKit.UITableViewCell {
        let cell: PokemonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let cellViewModel = PokemonCellViewModel(pokemon: pokemonList[indexPath.row])
        cell.viewModel = cellViewModel
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! PokemonCell).viewModel.start()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = pokemonList[indexPath.row]
        self.delegate?.didSelectPokemon(self)
    }
}
