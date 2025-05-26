//
//  PokeAPIService.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 24/05/25.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
        
    private init() {}
    
    let domainUrlString = "https://pokeapi.co/api/v2/"
        
    func fetchData(completionHandler: @escaping ([Pokemon]) -> Void) {
        let url = URL(string: domainUrlString + "/pokemon/")!
            
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("Request Error!")
                return
            }
                
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
                
            var result: [Pokemon]?
            do {
                result = try JSONDecoder().decode([Pokemon].self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            completionHandler(result ?? [])
        })
        task.resume()
    }
}
