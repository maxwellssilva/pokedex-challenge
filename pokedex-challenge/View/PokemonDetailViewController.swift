//
//  PokemonDetailViewController.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    private let viewModel: PokemonDetailViewModel
    
    private lazy var pokeball: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pokeball-background")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var pokeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return image
    }()
    
    private lazy var stackContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [nameLabel])
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var nameLabel = UILabel()
    lazy var attackLabel = UILabel()
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupPokeDetail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fire
        title = "Detalhes"
        setupPokeDetail()
        bindViewModel()
    }
    
    private func setupPokeDetail() {
        view.addSubview(pokeball)
        view.addSubview(pokeImage)
        view.addSubview(stackContainer)
        NSLayoutConstraint.activate([
            pokeball.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pokeball.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            pokeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            pokeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackContainer.topAnchor.constraint(equalTo: pokeImage.bottomAnchor, constant: 50),
            stackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        
        viewModel.pokemonName.bind { [weak self] name in
            self?.nameLabel.text = name
        }
            
        viewModel.pokemonImageUrl.bind { [weak self] imageUrlString in
            if let urlString = imageUrlString, let url = URL(string: urlString) {
                self?.pokeImage.download(from: url)
            } else {
                self?.pokeImage.image = nil
            }
        }
    }
}
