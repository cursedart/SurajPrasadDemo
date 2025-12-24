//
//  NetworkManager.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

protocol NetworkService {
    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, Error>
}

enum Endpoint: String {
    case portfolio = "35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
}

class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://"
    
    func getData<T>(endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        return Future<T, Error> { [weak self] promise in
            
            guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> JSONDecoder.Input in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder()).print() //debug
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                }).store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
