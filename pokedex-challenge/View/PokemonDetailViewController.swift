//
//  PokemonDetailViewController.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Detalhes"
        setupPokeDetail()
    }
    
    private func setupPokeDetail() {
        view.addSubview(pokeImage)
        NSLayoutConstraint.activate([
            pokeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
