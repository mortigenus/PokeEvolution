//
//  PokemonCell.swift
//  PokeEvolution
//
//  Created by Ivan Chalov on 16/07/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
// 

import UIKit

class PokemonCell: UITableViewCell, PokemonCellViewModelDelegate {
    @IBOutlet var name: UILabel!
    @IBOutlet var varieties: UILabel!
    @IBOutlet var habitat: UILabel!
    @IBOutlet var shape: UILabel!

    var viewModel: PokemonCellViewModel! {
        didSet {
            name.text = viewModel.name
            viewModel.delegate = self
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel.cancel()
        viewModel.delegate = nil
        name.text = nil
        varieties.text = nil
        habitat.text = nil
        shape.text = nil
    }

    func didFinishLoadingInfo(_ viewModel: PokemonCellViewModel) {
        name.text = viewModel.name
        varieties.text = viewModel.varieties
        habitat.text = viewModel.habitat
        shape.text = viewModel.shape
    }

}

extension PokemonCell: NibLoadableView {}
