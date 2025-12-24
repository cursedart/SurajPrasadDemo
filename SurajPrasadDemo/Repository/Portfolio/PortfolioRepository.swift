//
//  PortfolioRepository.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

protocol PortfolioRepository {
    func fetchHoldings() -> AnyPublisher<PortfolioResponse, Error>
}
