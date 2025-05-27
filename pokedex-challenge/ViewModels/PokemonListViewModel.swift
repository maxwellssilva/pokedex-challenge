//
//  PokemonViewModel.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 24/05/25.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    private var listener: ((T) -> Void)?
    init(_ value: T) { self.value = value }
    func bind(listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value)
    }
}

class PokemonListViewModel {
    var allPokemons: [PokemonResult] = []
    var displayedPokemons: [PokemonResult] = [] {
        didSet {
            reloadData.value = ()
        }
    }
    
    let isLoading: Observable<Bool> = Observable(false)
    let errorMessage: Observable<String?> = Observable(nil)
    let reloadData: Observable<Void> = Observable(())
    
    var searchText: String = "" {
        didSet {
            filterPokemons()
        }
    }
    
    private var currentPage = 0
    private let limit = 20
    private var totalPokemonCount = 0
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchPokemons() {
        guard !isLoading.value else { return }
        
        isLoading.value = true
        errorMessage.value = nil
        
        let offset = currentPage * limit
        let endpoint = "\(Constants.pokemonListEndpoint)?offset=\(offset)&limit=\(limit)"
        
        networkManager.fetchData(endpoint: endpoint) { [weak self] (result: Result<PokemonListResponse, APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading.value = false
                switch result {
                case .success(let response):
                    self.allPokemons.append(contentsOf: response.results)
                    self.totalPokemonCount = response.count
                    self.currentPage += 1
                    self.filterPokemons()
                case .failure(let error):
                    self.errorMessage.value = "Failed to fetch Pokemons: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchMorePokemonsIfNeeded(currentIndex: Int) {
        if allPokemons.count > 0 && currentIndex >= displayedPokemons.count - 5 && allPokemons.count < totalPokemonCount && !isLoading.value {
            fetchPokemons()
        }
    }
    
    private func filterPokemons() {
        if searchText.isEmpty {
            displayedPokemons = allPokemons
        } else {
            displayedPokemons = allPokemons.filter { pokemon in
                return pokemon.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func resetSearch() {
        searchText = ""
    }
}
