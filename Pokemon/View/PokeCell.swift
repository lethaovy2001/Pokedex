//
//  PokeCell.swift
//  Pokemon
//
//  Created by Vy Le on 2/19/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokedexImage: UIImageView!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
    }
    
    func configureCell (pokemon: Pokemon) {
        
        
        self.pokemon = pokemon
        
        nameLabel.text = pokemon.name.capitalized
        pokedexImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
    }
    
    
}
