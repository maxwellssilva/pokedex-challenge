//
//  PokeCell.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 26/05/25.
//

import UIKit

class PokeCell: UITableViewCell {
    
    static let identifier = "PokeCell"
    
    private lazy var stackViewHorizontal: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imagePokemon, stackViewVertical])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var stackViewVertical: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [namePokemon, numberPokemon])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var imagePokemon: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private lazy var namePokemon = configLabel()
    private lazy var numberPokemon = configLabel()
    
    private func configLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = .label
        return label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPokeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPokeCell() {
        addSubview(stackViewHorizontal)
        NSLayoutConstraint.activate([
            stackViewHorizontal.topAnchor.constraint(equalTo: topAnchor),
            stackViewHorizontal.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
