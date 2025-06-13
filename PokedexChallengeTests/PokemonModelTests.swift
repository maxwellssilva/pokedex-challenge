//
//  PokemonModelTests.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 12/06/25.
//

import XCTest
@testable import pokedex_challenge

class PokemonModelTests: XCTestCase {
    
    func testPokemonListResponseDecoding() throws {
        let json = """
        {
            "count": 1302,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            "previous": null,
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                },
                {
                    "name": "ivysaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/2/"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(PokemonListResponse.self, from: json)
        
        XCTAssertEqual(response.count, 1302)
        XCTAssertEqual(response.next, "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        XCTAssertNil(response.previous)
        XCTAssertEqual(response.results.count, 2)
        XCTAssertEqual(response.results[0].name, "bulbasaur")
        XCTAssertEqual(response.results[0].url, "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertEqual(response.results[1].name, "ivysaur")
        XCTAssertEqual(response.results[1].url, "https://pokeapi.co/api/v2/pokemon/2/")
    }
    
    func testPokemonDetailDecoding() throws {
        let json = """
                {
                    "id": 1,
                    "name": "bulbasaur",
                    "height": 7,
                    "weight": 69,
                    "sprites": {
                        "front_default": "url_default",
                        "other": {
                            "official-artwork": {
                                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                            }
                        }
                    },
                    "stats": [
                        {
                            "base_stat": 45,
                            "effort": 0,
                            "stat": {
                                "name": "hp",
                                "url": "https://pokeapi.co/api/v2/stat/1/"
                            }
                        }
                    ],
                    "types": [
                        {
                            "slot": 1,
                            "type": {
                                "name": "grass",
                                "url": "https://pokeapi.co/api/v2/type/12/"
                            }
                        }
                    ],
                    "species": {
                        "name": "bulbasaur",
                        "url": "https://pokeapi.co/api/v2/pokemon-species/1/"
                    }
                }
                """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let detail = try decoder.decode(PokemonDetail.self, from: json)
        
        XCTAssertEqual(detail.id, 1)
        XCTAssertEqual(detail.name, "bulbasaur")
        XCTAssertEqual(detail.height, 7)
        XCTAssertEqual(detail.weight, 69)
        XCTAssertEqual(detail.sprites.frontDefault, "url_default")
        XCTAssertEqual(detail.sprites.other?.officialArtwork?.frontDefault, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        
        XCTAssertEqual(detail.stats.count, 1)
        XCTAssertEqual(detail.stats[0].baseStat, 45)
        XCTAssertEqual(detail.stats[0].stat.name, "hp")
        
        XCTAssertEqual(detail.types.count, 1)
        XCTAssertEqual(detail.types[0].type.name, "grass")
        
        XCTAssertEqual(detail.species.name, "bulbasaur")
    }
    
    func testPokemonSpeciesDetailDecoding() throws {
        let json = """
            {
                "color": {
                    "name": "green",
                    "url": "https://pokeapi.co/api/v2/pokemon-color/5/"
                },
                "genera": [
                    {
                        "genus": "Seed Pokémon",
                        "language": {
                            "name": "en",
                            "url": "https://pokeapi.co/api/v2/language/9/"
                        }
                    },
                    {
                        "genus": "Pokémon Graine",
                        "language": {
                            "name": "fr",
                            "url": "https://pokeapi.co/api/v2/language/5/"
                        }
                    }
                ],
                "habitat": {
                    "name": "grassland",
                    "url": "https://pokeapi.co/api/v2/pokemon-habitat/2/"
                }
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let speciesDetail = try decoder.decode(PokemonSpeciesDetail.self, from: json)
        
        XCTAssertEqual(speciesDetail.color?.name, "green")
        XCTAssertEqual(speciesDetail.genera.count, 2)
        XCTAssertEqual(speciesDetail.genera[0].genus, "Seed Pokémon")
        XCTAssertEqual(speciesDetail.genera[0].language.name, "en")
        XCTAssertEqual(speciesDetail.habitat?.name, "grassland")
    }
}
