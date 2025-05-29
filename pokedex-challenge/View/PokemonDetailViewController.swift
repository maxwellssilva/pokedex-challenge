//
//  PokemonDetailViewController.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    private let viewModel: PokemonDetailViewModel
    
    private lazy var pokeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var stackContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [pokeImage])
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
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
        view.backgroundColor = .systemBackground
        title = "Detalhes"
        setupPokeDetail()
        bindViewModel()
    }
    
    private func setupPokeDetail() {
        view.addSubview(pokeImage)
        NSLayoutConstraint.activate([
            pokeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
            
        viewModel.pokemonImageUrl.bind { [weak self] imageUrlString in
            if let urlString = imageUrlString, let url = URL(string: urlString) {
                self?.pokeImage.download(from: url)
            } else {
                self?.pokeImage.image = nil // Ou uma imagem placeholder
            }
        }
    }
}
