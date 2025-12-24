//
//  PortfolioRepositoryImpl.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

final class PortfolioRepositoryImpl: PortfolioRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchHoldings() -> AnyPublisher<PortfolioResponse, Error> {
        networkService.getData(endpoint: .portfolio, type: PortfolioResponse.self
        )
    }
}
