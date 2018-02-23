//
//  PokemonDetailVC.swift
//  Pokemon
//
//  Created by Vy Le on 2/20/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evolutionLabel: UILabel!
    
    @IBOutlet weak var nameItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        
        nameItem.title = pokemon.name.capitalized
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        currentEvoImage.image = image
        mainImage.image = image
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
        
    }
    
    func updateUI () {
        baseAttackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        typeLabel.text = pokemon.type
        descriptionLabel.text = pokemon.description
        evolutionLabel.text = "Next Evolution: \(pokemon.nextEvolutionName)  Level: \(pokemon.nextEvolutionLevel)"
        nextEvoImage.image = UIImage(named: pokemon.nextEvolutionID)
    }

   
    

    

}
