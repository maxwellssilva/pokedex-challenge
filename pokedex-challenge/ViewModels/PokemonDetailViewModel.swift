//
//  PokemonDetailViewModel.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import UIKit

class PokemonDetailViewModel {
    let pokemonName: Observable<String>
    let pokemonIdDisplay: Observable<String>
    let pokemonImageUrl: Observable<String?>
    let pokemonTypesText: Observable<String?> = Observable(nil)
    let speciesCategory: Observable<String?> = Observable(nil)
    let viewBackgroundColor: Observable<UIColor?> = Observable(nil)
    let stats: Observable<[StatElement]> = Observable([])

    let isLoading: Observable<Bool> = Observable(false)
    let errorMessage: Observable<String?> = Observable(nil)

    private var currentPokemonDetail: PokemonDetail?
    private let pokemonID: Int
    private let networkManager: NetworkManager

    init(pokemon: PokemonResult, id: Int, networkManager: NetworkManager = .shared) {
        self.pokemonID = id
        self.networkManager = networkManager

        self.pokemonName = Observable(pokemon.name.capitalized)
        self.pokemonIdDisplay = Observable(String(format: "#%03d", id))
        self.pokemonImageUrl = Observable("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
        
        fetchDetails()
    }

    func fetchDetails() {
        isLoading.value = true
        errorMessage.value = nil
        
        let detailEndpoint = "\(Constants.pokemonListEndpoint)/\(pokemonID)/"

        networkManager.fetchData(endpoint: detailEndpoint) { [weak self] (result: Result<PokemonDetail, APIError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let detailData):
                self.currentPokemonDetail = detailData
                self.pokemonName.value = detailData.name.capitalized
                
                if let artworkUrl = detailData.sprites.other?.officialArtwork?.frontDefault {
                    self.pokemonImageUrl.value = artworkUrl
                }
                
                let typeNames = detailData.types.map { $0.type.name.capitalized }
                self.pokemonTypesText.value = typeNames.joined(separator: " / ")
                
                if let firstTypeName = detailData.types.first?.type.name {
                    self.viewBackgroundColor.value = self.colorForType(typeName: firstTypeName)
                } else {
                    self.viewBackgroundColor.value = UIColor(named: "defaultBackgroundColor") ?? .systemGray
                }
                
                self.stats.value = detailData.stats
                self.fetchSpeciesDetails(speciesURL: detailData.species.url)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage.value = "Failed to fetch Pokémon details: \(error.localizedDescription)"
                    self.isLoading.value = false
                }
            }
        }
    }

    private func fetchSpeciesDetails(speciesURL: String) {
        guard let url = URL(string: speciesURL) else {
            DispatchQueue.main.async {
                self.errorMessage.value = "Invalid species URL."
                self.isLoading.value = false
            }
            return
        }
        
        let pathComponents = url.pathComponents
        if let apiVersionIndex = pathComponents.firstIndex(of: "v2"), apiVersionIndex + 1 < pathComponents.count {
            let speciesEndpoint = pathComponents.suffix(from: apiVersionIndex + 1).joined(separator: "/")
            
            networkManager.fetchData(endpoint: speciesEndpoint) { [weak self] (result: Result<PokemonSpeciesDetail, APIError>) in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isLoading.value = false
                    switch result {
                    case .success(let speciesData):
                        if let genusEntry = speciesData.genera.first(where: { $0.language.name == "en" }) {
                            let cleanedGenus = genusEntry.genus.replacingOccurrences(of: " Pokémon", with: "")
                            self.speciesCategory.value = genusEntry.genus
                        }
                        
                        if self.viewBackgroundColor.value == nil || self.viewBackgroundColor.value == .systemGray {
                             if let speciesColorName = speciesData.color?.name {
                                 self.viewBackgroundColor.value = self.colorForType(typeName: speciesColorName)
                             }
                        }
                    case .failure(let error):
                        if self.errorMessage.value == nil {
                             self.errorMessage.value = "Failed to fetch species details: \(error.localizedDescription)"
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage.value = "Could not parse species endpoint from URL."
                self.isLoading.value = false
            }
        }
    }
    
    func colorForType(typeName: String) -> UIColor? {
        let colorName = typeName.lowercased()
        if let colorFromAssets = UIColor(named: colorName) {
            return colorFromAssets
        }
        
        switch colorName {
            case "normal": return UIColor(named: "normal")
            case "fighting": return UIColor(named: "fighting")
            case "flying": return UIColor(named: "flying")
            case "poison": return UIColor(named: "poison")
            case "ground": return UIColor(named: "ground")
            case "rock": return UIColor(named: "rock")
            case "ghost": return UIColor(named: "ghost")
            case "steel": return UIColor(named: "steel")
            case "water": return UIColor(named: "water")
            case "psychic": return UIColor(named: "psychic")
            case "ice": return UIColor(named: "ice")
            case "dark": return UIColor(named: "dark")
            case "fairy": return UIColor(named: "fairy")
            case "bug": return UIColor(named: "bug") ?? .systemGreen
            case "dragon": return UIColor(named: "dragon") ?? .systemIndigo
            case "electric": return UIColor(named: "electric") ?? .systemYellow
            case "fire": return UIColor(named: "fire") ?? .systemRed
            case "grass": return UIColor(named: "grass") ?? .systemGreen
            default: return UIColor.systemGray
        }
    }
}
