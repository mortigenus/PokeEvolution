//
//  PokemonListViewController.swift
//  PokeEvolution
//
//  Created by Ivan Chalov on 16/07/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
//

import UIKit

class PokemonListViewController: UITableViewController, PokemonListViewModelDelegate {

    var viewModel: PokemonListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueDidChange), for: .valueChanged)

        tableView.register(PokemonCell.self)
        tableView.rowHeight = 100

        // Providing the starting viewModel to the ListViewController
        // would require me to instantiate the VC by hand, so I decided to leave it here
        if viewModel == nil {
            viewModel = AllPokemonListViewModel()
        }

        viewModel.delegate = self

        tableView.dataSource = viewModel
        tableView.delegate = viewModel

        navigationItem.title = viewModel.title

        viewModel.viewDidLoad()
    }

    @objc
    func refreshControlValueDidChange() {
        viewModel.reloadRequested()
    }

    func didFinishLoadingPokemonList(_ viewModel: PokemonListViewModel) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func didSelectPokemon(_ viewModel: PokemonListViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PokemonList") as! PokemonListViewController
        if let viewModelForSelectedPokemon = viewModel.evolutionViewModelForSelectedPokemon() {
            controller.viewModel = viewModelForSelectedPokemon
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
