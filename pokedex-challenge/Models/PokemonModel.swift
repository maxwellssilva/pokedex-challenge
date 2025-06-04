//
//  Pokemon.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 24/05/25.
//

import UIKit

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResult]
}

struct PokemonResult: Codable {
    let name: String
    let url: String
}

struct Sprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// Em PokemonModel.swift

// Mantenha PokemonListResponse e PokemonResult como estão.

// MARK: - Pokemon Detail Model (para /pokemon/{id})
struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int // Altura em decímetros
    let weight: Int // Peso em hectogramas
    let sprites: PokemonSprites
    let stats: [StatElement]
    let types: [TypeElement]
    let species: APIResource // Link para buscar detalhes da espécie
    // Adicione 'abilities' se quiser listar as habilidades também
    // let abilities: [AbilityElement]
}

struct PokemonSprites: Codable {
    let frontDefault: String?
    let other: OtherSprites?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct StatElement: Codable {
    let baseStat: Int
    let stat: APIResource // Contém o nome do stat (e.g., "hp", "attack", "defense")

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct TypeElement: Codable {
    let slot: Int
    let type: APIResource // Contém o nome do tipo (e.g., "grass", "poison")
}

// struct AbilityElement: Codable {
//     let ability: APIResource
//     let isHidden: Bool
//     let slot: Int
//
//     enum CodingKeys: String, CodingKey {
//         case ability
//         case isHidden = "is_hidden"
//         case slot
//     }
// }

struct APIResource: Codable { // Estrutura genérica para links da API
    let name: String
    let url: String
}


// MARK: - Pokemon Species Detail Model (para /pokemon-species/{id})
struct PokemonSpeciesDetail: Codable {
    let color: APIResource? // Cor primária da espécie, pode ser usada como fallback
    let genera: [Genus] // Contém a "categoria" em diferentes idiomas (ex: "Seed Pokémon")
    let habitat: APIResource?
    // Adicione 'flavor_text_entries' se quiser exibir a descrição da Pokédex
    // let flavorTextEntries: [FlavorTextEntry]

    enum CodingKeys: String, CodingKey {
        case color, genera, habitat //, flavorTextEntries = "flavor_text_entries"
    }
}

struct Genus: Codable {
    let genus: String
    let language: APIResource // Para filtrar pelo idioma (ex: "en")
}

// struct FlavorTextEntry: Codable {
//     let flavorText: String
//     let language: APIResource
//
//     enum CodingKeys: String, CodingKey {
//         case flavorText = "flavor_text"
//         case language
//     }
// }

