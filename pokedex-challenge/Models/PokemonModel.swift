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

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let stats: [StatElement]
    let types: [TypeElement]
    let species: APIResource
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
    let stat: APIResource

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct TypeElement: Codable {
    let slot: Int
    let type: APIResource
}

struct APIResource: Codable {
    let name: String
    let url: String
}

struct PokemonSpeciesDetail: Codable {
    let color: APIResource?
    let genera: [Genus]
    let habitat: APIResource?
    
    enum CodingKeys: String, CodingKey {
        case color, genera, habitat
    }
}

struct Genus: Codable {
    let genus: String
    let language: APIResource
}
