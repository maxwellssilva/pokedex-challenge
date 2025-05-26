//
//  PokeAPIService.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 24/05/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unknown
}

class NetworkManager {
   
    static let shared = NetworkManager()

    private init() {}

    func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: Constants.baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                print("Decoding failed for \(T.self): \(error)")
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}
