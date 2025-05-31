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
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokedex = try? JSONDecoder().decode(Pokedex.self, from: jsonData)

// MARK: - Pokedex dados
struct Pokedex: Codable {
    let ability, berry, berryFirmness, berryFlavor: String
    let characteristic, contestEffect, contestType, eggGroup: String
    let encounterCondition, encounterConditionValue, encounterMethod, evolutionChain: String
    let evolutionTrigger, gender, generation, growthRate: String
    let item, itemAttribute, itemCategory, itemFlingEffect: String
    let itemPocket, language, location, locationArea: String
    let machine, move, moveAilment, moveBattleStyle: String
    let moveCategory, moveDamageClass, moveLearnMethod, moveTarget: String
    let nature, palParkArea, pokeathlonStat, pokedex: String
    let pokemon, pokemonColor, pokemonForm, pokemonHabitat: String
    let pokemonShape, pokemonSpecies, region, stat: String
    let superContestEffect, type, version, versionGroup: String

    enum CodingKeys: String, CodingKey {
        case ability, berry
        case berryFirmness = "berry-firmness"
        case berryFlavor = "berry-flavor"
        case characteristic
        case contestEffect = "contest-effect"
        case contestType = "contest-type"
        case eggGroup = "egg-group"
        case encounterCondition = "encounter-condition"
        case encounterConditionValue = "encounter-condition-value"
        case encounterMethod = "encounter-method"
        case evolutionChain = "evolution-chain"
        case evolutionTrigger = "evolution-trigger"
        case gender, generation
        case growthRate = "growth-rate"
        case item
        case itemAttribute = "item-attribute"
        case itemCategory = "item-category"
        case itemFlingEffect = "item-fling-effect"
        case itemPocket = "item-pocket"
        case language, location
        case locationArea = "location-area"
        case machine, move
        case moveAilment = "move-ailment"
        case moveBattleStyle = "move-battle-style"
        case moveCategory = "move-category"
        case moveDamageClass = "move-damage-class"
        case moveLearnMethod = "move-learn-method"
        case moveTarget = "move-target"
        case nature
        case palParkArea = "pal-park-area"
        case pokeathlonStat = "pokeathlon-stat"
        case pokedex, pokemon
        case pokemonColor = "pokemon-color"
        case pokemonForm = "pokemon-form"
        case pokemonHabitat = "pokemon-habitat"
        case pokemonShape = "pokemon-shape"
        case pokemonSpecies = "pokemon-species"
        case region, stat
        case superContestEffect = "super-contest-effect"
        case type, version
        case versionGroup = "version-group"
    }
}

