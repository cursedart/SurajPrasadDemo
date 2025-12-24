//
//  PortfolioViewModelTests.swift
//  SurajPrasadDemoTests
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import XCTest
import Combine
@testable import SurajPrasadDemo

final class PortfolioViewModelTests: XCTestCase {

    private var viewModel: PortfolioViewModel!
    private var mockRepository: MockPortfolioRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockPortfolioRepository()
        viewModel = PortfolioViewModel(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_initialState_isCorrect() {
        XCTAssertTrue(viewModel.holdings.isEmpty)
        XCTAssertNil(viewModel.portfolioSummary)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchHoldings_setsLoadingStateCorrectly() {
        mockRepository.result = .success(
            PortfolioResponse(data: PortfolioData(userHoldings: []))
        )

        let expectation = expectation(description: "Loading toggled")
        expectation.expectedFulfillmentCount = 2

        viewModel.loadingPublisher
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchHoldings()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_fetchHoldings_success_updatesHoldingsAndSummary() {
        let holdings = [
            Holding(symbol: "AAPL", quantity: 10, lastTradedPrice: 20, averagePrice: 15, closePrice: 19),
            Holding(symbol: "GOOG", quantity: 10, lastTradedPrice: 30, averagePrice: 25, closePrice: 31)
        ]

        let response = PortfolioResponse(data: PortfolioData(userHoldings: holdings))
        mockRepository.result = .success(response)

        let expectation = expectation(description: "Holdings updated")

        viewModel.holdingsPublisher
            .filter { !$0.isEmpty }
            .sink { values in
                XCTAssertEqual(values.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchHoldings()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.portfolioSummary?.totalCurrentValue, 500)
        XCTAssertEqual(viewModel.portfolioSummary?.totalInvestment, 400)
        XCTAssertEqual(viewModel.portfolioSummary?.overallProfitOrLoss, 100)
        XCTAssertEqual(viewModel.portfolioSummary?.todaysProfitOrLoss, 0)
    }
}
