//
//  ViewController.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 24/05/25.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    private let viewModel: PokemonListViewModel

    init(viewModel: PokemonListViewModel = PokemonListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Pesquise um Pokémon"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .systemBackground
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let list = UITableView()
        list.delegate = self
        list.dataSource = self
        list.register(PokeCell.self, forCellReuseIdentifier: PokeCell.identifier)
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pokédex"
        setupLayoutPokemonList()
        bindViewModel()
        viewModel.fetchPokemons()
    }

    func setupLayoutPokemonList() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }

        viewModel.errorMessage.bind { [weak self] message in
            DispatchQueue.main.async {
                if let msg = message, !msg.isEmpty {
                    self?.showAlert(message: msg)
                }
            }
        }

        viewModel.reloadData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayPokemons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeCell.identifier, for: indexPath) as? PokeCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.displayPokemons[indexPath.row]
        
        let idString = pokemon.url.components(separatedBy: "/").dropLast().last ?? "1"
        let pokemonID = Int(idString) ?? (indexPath.row + 1)
        
        cell.configure(with: pokemon.name, id: pokemonID)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.searchText.isEmpty {
            viewModel.fetchMorePokemonsIfNeeded(currentIndex: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPokemon = viewModel.displayPokemons[indexPath.row]
        // Extrai o ID do Pokémon da URL
        let idString = selectedPokemon.url.components(separatedBy: "/").dropLast().last ?? "1"
        guard let pokemonID = Int(idString) else {
            print("Erro ao extrair ID do Pokémon da URL: \(selectedPokemon.url)")
            return
        }
        // 1. Instancia a ViewModel da tela de detalhes, passando o Pokémon e o ID
        let detailViewModel = PokemonDetailViewModel(pokemon: selectedPokemon, id: pokemonID)
        // 2. Instancia a ViewController de detalhes, injetando a ViewModel
        let detailViewController = PokemonDetailViewController(viewModel: detailViewModel)
        // 3. Empurra a nova ViewController para a pilha de navegação
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PokemonListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.resetSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
