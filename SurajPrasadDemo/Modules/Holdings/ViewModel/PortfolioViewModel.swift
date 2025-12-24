//
//  PortfolioSummaryViewModel.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

final class PortfolioViewModel: PortfolioViewModelProtocol, ObservableObject {

    private var cancellables = Set<AnyCancellable>()
    
    internal var holdings: [Holding] = []
    internal var fetchedholdings = PassthroughSubject<Result<Bool, Error>, Never>()
    
    private let repository: PortfolioRepository

    var totalCurrentValue: Double = 0
    var totalInvestment: Double = 0
    var overallProfitOrLoss: Double = 0
    var todaysProfitOrLoss: Double = 0

    required init(repository: PortfolioRepository) {
        self.repository = repository
    }
    
    private func portfolioSummaryCalculations() {
        self.totalCurrentValue = holdings.reduce(0) { $0 + $1.currentValue }
        self.totalInvestment = holdings.reduce(0) { $0 + $1.investedValue }
        self.overallProfitOrLoss = totalCurrentValue - totalInvestment
        self.todaysProfitOrLoss = holdings.reduce(0) { $0 + $1.todaysProfitOrLoss }
    }
    
    func getHoldings() {
        repository.fetchHoldings()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                    self?.fetchedholdings.send(.failure(err))
                case .finished:
                    print("Finished")
                    self?.fetchedholdings.send(.success(true))
                }
            }
    
            receiveValue: { [weak self] holdings in
                guard let self else { return }
                self.holdings = holdings.data?.userHoldings ?? []
                self.portfolioSummaryCalculations()
                //self.fetchedholdings.send(.success(true))
            }
            .store(in: &cancellables)
    }
}
