//
//  PokemonDetailViewModel.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import Foundation

class PokemonDetailViewModel {
    let pokemonName: Observable<String>
    let pokemonImageUrl: Observable<String?>
    let pokemonId: Observable<Int>
    
    init(pokemon: PokemonResult, id: Int) {
        self.pokemonName = Observable(pokemon.name.capitalized)
        self.pokemonImageUrl = Observable("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
        self.pokemonId = Observable(id)
    }
}
