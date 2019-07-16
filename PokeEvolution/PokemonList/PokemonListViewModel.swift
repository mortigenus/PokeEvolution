//
// Created by Ivan Chalov on 2019-07-16.
// Copyright (c) 2019 Ivan Chalov. All rights reserved.
//

import UIKit

protocol PokemonListViewModelDelegate: class {
    func didFinishLoadingPokemonList(_ viewModel: PokemonListViewModel)
    func didSelectPokemon(_ viewModel: PokemonListViewModel)
}

protocol PokemonListViewModel: UITableViewDataSource, UITableViewDelegate {
    var delegate: PokemonListViewModelDelegate? { get set }
    var title: String { get }

    func viewDidLoad()
    func reloadRequested()
    func evolutionViewModelForSelectedPokemon() -> PokemonListViewModel?
}
