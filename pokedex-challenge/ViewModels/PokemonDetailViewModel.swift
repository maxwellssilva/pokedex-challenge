//
//  PokemonDetailViewModel.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import UIKit

class PokemonDetailViewModel {
    // Observables para a View
    let pokemonName: Observable<String>
    let pokemonIdDisplay: Observable<String> // Ex: "#001"
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
        // URL da imagem oficial (artwork)
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
                // Atualiza o nome com o que veio da API de detalhes (pode ter capitalização diferente)
                self.pokemonName.value = detailData.name.capitalized
                
                // Atualiza a URL da imagem se a do endpoint de detalhes for preferida e existir
                if let artworkUrl = detailData.sprites.other?.officialArtwork?.frontDefault {
                    self.pokemonImageUrl.value = artworkUrl
                }
                
                let typeNames = detailData.types.map { $0.type.name.capitalized }
                self.pokemonTypesText.value = typeNames.joined(separator: " / ")
                
                if let firstTypeName = detailData.types.first?.type.name {
                    self.viewBackgroundColor.value = self.colorForType(typeName: firstTypeName)
                } else {
                    self.viewBackgroundColor.value = UIColor(named: "defaultBackgroundColor") ?? .systemGray // Cor padrão
                }
                
                self.stats.value = detailData.stats
                
                // Busca os detalhes da espécie
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
        // O NetworkManager espera um endpoint relativo à baseURL.
        // Precisamos extrair o path da URL completa da espécie.
        guard let url = URL(string: speciesURL) else {
            DispatchQueue.main.async {
                self.errorMessage.value = "Invalid species URL."
                self.isLoading.value = false // Finaliza o loading aqui se a URL da espécie for inválida
            }
            return
        }
        
        // Exemplo: https://pokeapi.co/api/v2/pokemon-species/1/ -> pokemon-species/1/
        let pathComponents = url.pathComponents
        // Encontra o índice de "v2" e pega o restante
        if let apiVersionIndex = pathComponents.firstIndex(of: "v2"), apiVersionIndex + 1 < pathComponents.count {
            let speciesEndpoint = pathComponents.suffix(from: apiVersionIndex + 1).joined(separator: "/")
            
            networkManager.fetchData(endpoint: speciesEndpoint) { [weak self] (result: Result<PokemonSpeciesDetail, APIError>) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isLoading.value = false // Finaliza o loading após a segunda chamada
                    switch result {
                    case .success(let speciesData):
                        if let genusEntry = speciesData.genera.first(where: { $0.language.name == "en" }) {
                            self.speciesCategory.value = genusEntry.genus
                        }
                        // Opcional: Usar speciesData.color.name como fallback para backgroundColor se o tipo não definir uma cor
                        if self.viewBackgroundColor.value == nil || self.viewBackgroundColor.value == .systemGray {
                             if let speciesColorName = speciesData.color?.name {
                                 self.viewBackgroundColor.value = self.colorForType(typeName: speciesColorName)
                             }
                        }
                    case .failure(let error):
                        // Não sobrescrever um erro mais crítico da primeira chamada
                        if self.errorMessage.value == nil {
                             self.errorMessage.value = "Failed to fetch species details: \(error.localizedDescription)"
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage.value = "Could not parse species endpoint from URL."
                self.isLoading.value = false // Finaliza o loading
            }
        }
    }
    
    // Mapeia o nome do tipo para uma cor. Você tem assets para:
    // bug, dragon, electric, fire, grass
    func colorForType(typeName: String) -> UIColor? {
        let colorName = typeName.lowercased()
        // Tenta carregar diretamente do asset catalog (assumindo que os nomes dos Color Sets são os nomes dos tipos)
        if let colorFromAssets = UIColor(named: colorName) {
            return colorFromAssets
        }
        
        // Se seus assets estiverem em uma pasta "colors", use:
        // if let colorFromAssets = UIColor(named: "colors/\(colorName)") {
        //     return colorFromAssets
        // }

        // Fallback para cores hardcoded se não encontrar no asset ou para tipos comuns não listados nos seus assets.
        switch colorName {
            case "normal": return UIColor(red: 0.66, green: 0.65, blue: 0.47, alpha: 1.00) // A8A878
            case "fighting": return UIColor(red: 0.75, green: 0.19, blue: 0.16, alpha: 1.00) // C03028
            case "flying": return UIColor(red: 0.66, green: 0.56, blue: 0.94, alpha: 1.00) // A890F0
            case "poison": return UIColor(red: 0.63, green: 0.25, blue: 0.63, alpha: 1.00) // A040A0
            case "ground": return UIColor(red: 0.88, green: 0.75, blue: 0.40, alpha: 1.00) // E0C068
            case "rock": return UIColor(red: 0.71, green: 0.63, blue: 0.22, alpha: 1.00) // B8A038
            case "ghost": return UIColor(red: 0.44, green: 0.34, blue: 0.59, alpha: 1.00) // 705898
            case "steel": return UIColor(red: 0.72, green: 0.72, blue: 0.81, alpha: 1.00) // B8B8D0
            case "water": return UIColor(red: 0.40, green: 0.56, blue: 0.94, alpha: 1.00) // 6890F0
            case "psychic": return UIColor(red: 0.97, green: 0.34, blue: 0.53, alpha: 1.00) // F85888
            case "ice": return UIColor(red: 0.60, green: 0.85, blue: 0.85, alpha: 1.00) // 98D8D8
            case "dark": return UIColor(red: 0.44, green: 0.34, blue: 0.28, alpha: 1.00) // 705848
            case "fairy": return UIColor(red: 0.93, green: 0.60, blue: 0.69, alpha: 1.00) // EE99AC
            // Seus assets:
            case "bug": return UIColor(named: "bug") ?? .systemGreen
            case "dragon": return UIColor(named: "dragon") ?? .systemIndigo
            case "electric": return UIColor(named: "electric") ?? .systemYellow
            case "fire": return UIColor(named: "fire") ?? .systemRed
            case "grass": return UIColor(named: "grass") ?? .systemGreen
            default: return UIColor.systemGray // Cor padrão para tipos não mapeados
        }
    }
}
