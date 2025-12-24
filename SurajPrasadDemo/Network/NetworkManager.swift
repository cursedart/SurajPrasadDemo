//
//  NetworkManager.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

final class NetworkManager: NetworkService {

    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "https://"

    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: self.baseURL.appending(endpoint.path)) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.responseError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
