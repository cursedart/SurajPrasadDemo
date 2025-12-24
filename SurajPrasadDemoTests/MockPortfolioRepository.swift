//
//  MockPortfolioRepository.swift
//  SurajPrasadDemoTests
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import Combine
@testable import SurajPrasadDemo

final class MockPortfolioRepository: PortfolioRepository {

    var result: Result<PortfolioResponse, Error>!

    func fetchHoldings() -> AnyPublisher<PortfolioResponse, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}
