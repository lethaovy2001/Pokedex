//
//  Pokemon.swift
//  Pokemon
//
//  Created by Vy Le on 2/19/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _attack: String!
    private var _height: String!
    private var _weight: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionLevel: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }

    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            //MARK: Download data for weight, height, defense and attack
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {

                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }

                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }

                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    
                    if let defense = stats[3]["base_stat"] as? Int {
                        self._defense = "\(defense)"
                    }
                    
                    if let attack = stats[4]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                    
                }
                
                //MARK: Download data for types
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    
                    if let type = types[0]["type"] as? Dictionary<String, AnyObject> {
                        if let name = type["name"] as? String {
                            self._type = name.capitalized
                        }
                    }
                    
                    if types.count > 1 {
                        for i in 1..<types.count {
                            if let type = types[i]["type"] as? Dictionary<String, AnyObject> {
                                if let name = type["name"] as? String {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                //MARK: Download data for descriptions
                
                if let species = dict["species"] as? Dictionary <String, AnyObject > {
                    
                    if let url = species["url"] as? String {
                        
                        if url != "" {
                        
                            let speciesURL = "\(URL_BASE)\(URL_SPECIES)\(self.pokedexId)"
                        
                            Alamofire.request(speciesURL).responseJSON(completionHandler: { (response) in
                            
                            
                            if let speciesDict = response.result.value as? Dictionary <String, AnyObject> {
                                
                                if let flavorTextEntries = speciesDict["flavor_text_entries"] as? [Dictionary <String, AnyObject>] {
                                    
                                    var i = 0
                                    
                                    while i < flavorTextEntries.count {
                                        
                                        if let language = flavorTextEntries[i]["language"] as? Dictionary<String, AnyObject> {
                                            
                                            if let name = language["name"] as? String {

                                             
                                                if name == "en" {
                                                    
                                                    if let flavorText = flavorTextEntries[i]["flavor_text"] as? String {
                                                        self._description = flavorText
                                                        
                                                        let trimmed = self._description.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
                                                        self._description = self._description.replacingOccurrences(of: "POKMON", with: "Pokémon", options: .regularExpression)
                                                        
                                                        self._description = self._description.replacingOccurrences(of: ".", with: ". ", options: .regularExpression)
                                                        
                                                        self._description = self._description.replacingOccurrences(of: ",", with: ", ", options: .regularExpression)
                                                        
                                                        self._description = trimmed
                                                        
                                                        i += 100
                                                    }
                                                    
                                                }
                                                
                                                i += 1
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                                //MARK: Download data for the next evolution
                                
                                if let evolutionChain = speciesDict["evolution_chain"] as? Dictionary <String, AnyObject> {
                                    
                                    if (evolutionChain["url"] as? String) != nil {
                                        
                                        self._nextEvolutionName = "\(self.pokedexId)"
                                        
                                        let evolutionURL = "\(URL_BASE)\(URL_EVOLUTION)\(self.pokedexId)"
                                        Alamofire.request(evolutionURL).responseJSON(completionHandler: { (response) in
                                            
                                            if let evoDict = response.result.value as? Dictionary <String, AnyObject> {
                                                
                                                if let chain = evoDict["chain"] as? Dictionary <String, AnyObject> {
                                                    
                                                    if let evolvesTo = chain["evolves_to"] as? [Dictionary<String, AnyObject>] {
                                                        
                                                        if let evolutionDetails = evolvesTo[0]["evolution_details"] as? [Dictionary<String, AnyObject>] {
                                                            
                                                            if let level = evolutionDetails[0]["min_level"] as? Int {
                                                            self._nextEvolutionLevel = "\(level)"
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        if let species = evolvesTo[0]["species"] as? Dictionary <String, AnyObject> {
                                                            if let name = species["name"] as? String {
                                                                self._nextEvolutionName = name.capitalized
                                                                self._nextEvolutionID = "\(self.pokedexId + 1)"
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                           completed()
                                        })
                                        
                                    }
                                    
                                }
                                
                            }
                            completed()
                        })
                        
                    }
                    }
                }
            }
            completed()
            

        }
    }
    
    
    
    
    
    
    
}
