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
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var stackViewVertical: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [namePokemon, numberPokemon])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var imagePokemon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return image
    }()

    private lazy var namePokemon: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var numberPokemon: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPokeCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPokeCell() {
        contentView.addSubview(stackViewHorizontal)
        accessoryType = .disclosureIndicator
        NSLayoutConstraint.activate([
            stackViewHorizontal.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackViewHorizontal.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewHorizontal.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackViewHorizontal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with name: String, id: Int) {
        namePokemon.text = name.capitalized
        numberPokemon.text = String(format: "#%03d", id)

        // TODO: Usar aquela extension de download Common/Utils/Extension+Download para obter URL de imagem
        let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        imagePokemon.download(from: imageUrlString)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imagePokemon.image = nil
        namePokemon.text = nil
        numberPokemon.text = nil
    }
}
