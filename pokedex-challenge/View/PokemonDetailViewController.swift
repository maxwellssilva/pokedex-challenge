//
//  PokemonDetailViewController.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 29/05/25.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    private let viewModel: PokemonDetailViewModel
    
    private lazy var headerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pokeballImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pokeball-3")
        image.contentMode = .scaleAspectFit
        image.alpha = 1.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var typesPillStackView: UIStackView = { // NOVA STACKVIEW
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8 // Espaçamento entre as pílulas
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameIdTypeStackView,
            //typesPillStackView,
            //speciesLabel,
            statsHeaderLabel,
            statsStackView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameIdTypeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, idLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()

    private lazy var typesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var statsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Base Stats"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()

    private lazy var statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupLayoutDetailScreen()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward"), transitionMaskImage: UIImage(systemName: "arrow.backward"))

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = " "
    }
    
    private func setupLayoutDetailScreen() {
        view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(pokeballImageView)
        headerBackgroundView.addSubview(pokemonImageView)
        headerBackgroundView.addSubview(nameIdTypeStackView)
        headerBackgroundView.addSubview(activityIndicator)
        
        view.addSubview(typesPillStackView)

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        let headerHeight: CGFloat = view.bounds.height * 0.40
        NSLayoutConstraint.activate([
            headerBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackgroundView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            pokeballImageView.topAnchor.constraint(equalTo: headerBackgroundView.safeAreaLayoutGuide.topAnchor, constant: -16),
            pokeballImageView.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -10),
            pokeballImageView.widthAnchor.constraint(equalTo: headerBackgroundView.widthAnchor, multiplier: 0.6),
            pokeballImageView.heightAnchor.constraint(equalTo: pokeballImageView.widthAnchor),

            pokemonImageView.centerXAnchor.constraint(equalTo: headerBackgroundView.centerXAnchor),
            pokemonImageView.centerYAnchor.constraint(equalTo: headerBackgroundView.centerYAnchor, constant: 30),
            pokemonImageView.heightAnchor.constraint(equalTo: headerBackgroundView.heightAnchor, multiplier: 0.5),
            pokemonImageView.widthAnchor.constraint(equalTo: pokemonImageView.heightAnchor),
            
            nameIdTypeStackView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 8),
            nameIdTypeStackView.leadingAnchor.constraint(equalTo: headerBackgroundView.leadingAnchor, constant: 20),
            nameIdTypeStackView.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -20),
            nameIdTypeStackView.bottomAnchor.constraint(lessThanOrEqualTo: headerBackgroundView.bottomAnchor, constant: -20),

            activityIndicator.centerXAnchor.constraint(equalTo: headerBackgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: headerBackgroundView.centerYAnchor),
            
            typesPillStackView.topAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: 10),
            typesPillStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            typesPillStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            typesPillStackView.bottomAnchor.constraint(equalTo: scrollView.topAnchor),
            
            scrollView.topAnchor.constraint(equalTo: typesPillStackView.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: -70),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let msg = message, !msg.isEmpty {
                    self.showAlert(message: msg)
                }
            }
        }
        
        viewModel.pokemonName.bind { [weak self] name in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.nameLabel.text = name
                self.title = name
            }
        }
        
        viewModel.pokemonIdDisplay.bind { [weak self] idText in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.idLabel.text = idText
            }
        }
        
        viewModel.pokemonImageUrl.bind { [weak self] imageUrlString in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let urlString = imageUrlString, let url = URL(string: urlString) {
                    self.pokemonImageView.download(from: url)
                } else {
                    self.pokemonImageView.image = UIImage(systemName: "questionmark.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                }
            }
        }
        
        viewModel.viewBackgroundColor.bind { [weak self] color in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let finalColor = color ?? UIColor.systemGray
                self.headerBackgroundView.backgroundColor = finalColor
            }
        }
        
        viewModel.pokemonTypesText.bind { [weak self] typesText in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.typesPillStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Limpa pílulas existentes
                
                if let typesString = typesText, !typesString.isEmpty {
                    let typeNames = typesString.components(separatedBy: " / ")
                    for typeName in typeNames {
                        let pillLabel = self.createTypePill(typeName: typeName)
                        self.typesPillStackView.addArrangedSubview(pillLabel)
                    }
                }
            }
        }
        
        viewModel.speciesCategory.bind { [weak self] category in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.speciesLabel.text = category ?? "Unknown species"
            }
        }
        
        viewModel.stats.bind { [weak self] statsData in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateStatsUI(stats: statsData)
            }
        }
    }


    private func updateStatsUI(stats: [StatElement]) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let statOrder: [String: String] = [
            "hp": "HP",
            "attack": "Attack",
            "defense": "Defense",
            "special-attack": "Sp. Atk",
            "special-defense": "Sp. Def",
            "speed": "Speed"
        ]
        
        let maxStatValue: Float = 255.0

        for (key, displayName) in statOrder {
            if let statInfo = stats.first(where: { $0.stat.name.lowercased() == key }) {
                let statView = createStatRow(name: displayName, value: statInfo.baseStat, maxValue: maxStatValue)
                statsStackView.addArrangedSubview(statView)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func createTypePill(typeName: String) -> UILabel {
        let label = UILabel()
        label.text = typeName
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 12 // Metade da altura esperada para um visual de pílula
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Cor de fundo baseada no tipo (usando sua função existente)
        label.backgroundColor = viewModel.colorForType(typeName: typeName) ?? .systemGray
        
        // Padding
        let padding: CGFloat = 8
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: label.intrinsicContentSize.width + (padding * 2)).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true // Altura fixa para a pílula
        
        return label
    }

    private func createStatRow(name: String, value: Int, maxValue: Float) -> UIView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .systemGray
        nameLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true

        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = .label
        valueLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true

        let progressBar = UIProgressView(progressViewStyle: .default)
        let progress = Float(value) / maxValue
        progressBar.setProgress(progress, animated: true)
        progressBar.progressTintColor = viewModel.viewBackgroundColor.value ?? .systemBlue
        progressBar.trackTintColor = UIColor.systemGray5
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.heightAnchor.constraint(equalToConstant: 8).isActive = true

        hStack.addArrangedSubview(nameLabel)
        hStack.addArrangedSubview(valueLabel)
        hStack.addArrangedSubview(progressBar)
        
        return hStack
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
