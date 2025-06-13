//
//  NetworkManagerTests.swift
//  pokedex-challenge
//
//  Created by Maxwell Silva on 12/06/25.
//

import XCTest
@testable import pokedex_challenge

// MARK: - Mock para respostas de rede
class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

class MockURLSession: URLSessionProtocol {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?

    private (set) var lastURL: URL?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.lastURL = url
        return MockURLSessionDataTask { [weak self] in
            completionHandler(self?.nextData, self?.nextResponse, self?.nextError)
        }
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.lastURL = request.url
        return MockURLSessionDataTask { [weak self] in
            completionHandler(self?.nextData, self?.nextResponse, self?.nextError)
        }
    }
}

// MARK: - Protocolo de NetworkManager para ser testável
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: - Camada de netwworking modificado para aceitar um URLSessionProtocol
class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    enum APIError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingFailed(Error)
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .invalidURL: return "Invalid URL"
            case .requestFailed(let error): return "Request failed: \(error.localizedDescription)"
            case .invalidResponse: return "Invalid response from server"
            case .decodingFailed(let error): return "Failed to decode response: \(error.localizedDescription)"
            case .unknown: return "An unknown error occurred"
            }
        }
    }

    func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: Constants.baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        session.dataTask(with: url) { data, response, error in
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


class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var mockSession: MockURLSession!

    override func setUpWithError() throws {
        mockSession = MockURLSession()
        sut = NetworkManager(session: mockSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
    }

    func testFetchData_Success() {
        let expectation = XCTestExpectation(description: "Fetch data success")
        let mockData = """
        {
            "count": 1,
            "results": [{"name": "test", "url": "testurl"}]
        }
        """.data(using: .utf8)!
        mockSession.nextData = mockData
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: Constants.baseURL + "pokemon")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.fetchData(endpoint: "pokemon") { (result: Result<PokemonListResponse, APIError>) in

            switch result {
            case .success(let response):
                XCTAssertEqual(response.count, 1)
                XCTAssertEqual(response.results.first?.name, "test")
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockSession.lastURL?.absoluteString, Constants.baseURL + "pokemon")
    }

    func testFetchData_InvalidURL() {
        let expectation = XCTestExpectation(description: "Fetch data invalid URL")
        
        sut.fetchData(endpoint: " invalid url") { (result: Result<PokemonListResponse, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                XCTAssertEqual(error, APIError.invalidURL)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchData_RequestFailed() {
        let expectation = XCTestExpectation(description: "Fetch data request failed")
        let mockError = NSError(domain: "test", code: 1, userInfo: nil)
        mockSession.nextError = mockError

        sut.fetchData(endpoint: "pokemon") { (result: Result<PokemonListResponse, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                if case .requestFailed(let receivedError) = error {
                    XCTAssertEqual(receivedError as NSError, mockError)
                } else {
                    XCTFail("Expected .requestFailed error, but got \(error)")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchData_InvalidResponseStatusCode() {
        let expectation = XCTestExpectation(description: "Fetch data invalid response status code")
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: Constants.baseURL + "pokemon")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        mockSession.nextData = "{}".data(using: .utf8)!

        sut.fetchData(endpoint: "pokemon") { (result: Result<PokemonListResponse, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                XCTAssertEqual(error, APIError.invalidResponse)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchData_DecodingFailed() {
        let expectation = XCTestExpectation(description: "Fetch data decoding failed")
        let invalidData = "{\"wrong_key\": \"value\"}".data(using: .utf8)!
        mockSession.nextData = invalidData
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: Constants.baseURL + "pokemon")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.fetchData(endpoint: "pokemon") { (result: Result<PokemonListResponse, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                if case .decodingFailed = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Expected .decodingFailed error, but got \(error)")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
