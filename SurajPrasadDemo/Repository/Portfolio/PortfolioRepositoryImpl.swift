//
//  PortfolioRepositoryImpl.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

final class PortfolioRepositoryImpl: PortfolioRepository {

    private let remote: NetworkService
    private let local: HoldingsLocalDataSource

    init(remote: NetworkService, local: HoldingsLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    func fetchHoldings() -> AnyPublisher<PortfolioResponse, Error> {

        self.remote.getData(endpoint: .portfolio, type: PortfolioResponse.self)
            .handleEvents(receiveOutput: { [weak self] response in
                guard let self else { return }
                let holdings = response.data?.userHoldings ?? []
                self.local.saveHoldings(holdings)
            })
            .catch { [weak self] _ -> AnyPublisher<PortfolioResponse, Error> in
                guard let self else {
                    return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
                }

                let cached = self.local.fetchHoldings()
                let response = PortfolioResponse(data: PortfolioData(userHoldings: cached))
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
