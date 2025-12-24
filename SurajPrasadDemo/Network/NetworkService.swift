//
//  NetworkService.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

protocol NetworkService {
    func getData<T: Decodable>(endpoint: Endpoint,type: T.Type) -> AnyPublisher<T, Error>
}
