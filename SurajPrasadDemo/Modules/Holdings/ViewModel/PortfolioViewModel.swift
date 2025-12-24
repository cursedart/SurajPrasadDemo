//
//  PortfolioSummaryViewModel.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

final class PortfolioViewModel: PortfolioViewModelProtocol, ObservableObject {

    // MARK: - Published State

    @Published private(set) var holdings: [Holding] = []
    @Published private(set) var portfolioSummary: PortfolioSummary?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    // MARK: - Publishers

    var holdingsPublisher: AnyPublisher<[Holding], Never> {
        self.$holdings.eraseToAnyPublisher()
    }

    var portfolioSummaryPublisher: AnyPublisher<PortfolioSummary?, Never> {
        self.$portfolioSummary.eraseToAnyPublisher()
    }

    var loadingPublisher: AnyPublisher<Bool, Never> {
        self.$isLoading.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<String?, Never> {
        self.$errorMessage.eraseToAnyPublisher()
    }

    // MARK: - Dependencies

    private let repository: PortfolioRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(repository: PortfolioRepository) {
        self.repository = repository
    }

    // MARK: - API Call
    
    private func resetState(clearData: Bool) {
        if clearData {
            self.holdings = []
            self.portfolioSummary = nil
        }
        self.isLoading = true
        self.errorMessage = nil
    }

    func fetchHoldings(isRefreshing: Bool = false) {
        self.resetState(clearData: !isRefreshing)

        self.repository.fetchHoldings()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false

                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }

                let holdings = response.data?.userHoldings ?? []
                self.holdings = holdings
                self.portfolioSummary = self.calculateSummary(from: holdings)
            }
            .store(in: &self.cancellables)
    }

    private func calculateSummary(from holdings: [Holding]) -> PortfolioSummary {

        let totalCurrentValue = holdings.reduce(0) { $0 + $1.currentValue }
        let totalInvestment = holdings.reduce(0) { $0 + $1.investedValue }
        let todaysProfitOrLoss = holdings.reduce(0) { $0 + $1.todaysProfitOrLoss }
        let overallProfitOrLoss = totalCurrentValue - totalInvestment

        return PortfolioSummary(
            totalCurrentValue: totalCurrentValue,
            totalInvestment: totalInvestment,
            overallProfitOrLoss: overallProfitOrLoss,
            todaysProfitOrLoss: todaysProfitOrLoss
        )
    }
}
