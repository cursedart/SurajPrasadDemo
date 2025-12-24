//
//  PortfolioSummaryViewModelProtocol.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

protocol PortfolioViewModelProtocol: AnyObject {

    // MARK: - State
    
    var holdings: [Holding] { get }
    var portfolioSummary: PortfolioSummary? { get }

    var isLoading: Bool { get }
    var errorMessage: String? { get }

    // MARK: - Publishers
    
    var holdingsPublisher: AnyPublisher<[Holding], Never> { get }
    var portfolioSummaryPublisher: AnyPublisher<PortfolioSummary?, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<String?, Never> { get }

    // MARK: - Actions
    func fetchHoldings()
}
