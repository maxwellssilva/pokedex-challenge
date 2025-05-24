//
//  ViewController.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 24/05/25.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let list = UITableView()
        list.delegate = self
        list.dataSource = self
        list.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    //return UITableViewCell
    
}
