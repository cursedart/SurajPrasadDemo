//
//  PortfolioResponse.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation

// MARK: - Portfolio Response

struct PortfolioResponse: Decodable {

    let data: PortfolioData?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(PortfolioData.self, forKey: .data)
    }

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Data Container
struct PortfolioData: Decodable {

    let userHoldings: [Holding]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userHoldings = try container.decodeIfPresent([Holding].self, forKey: .userHoldings)
    }

    enum CodingKeys: String, CodingKey {
        case userHoldings = "userHolding"
    }
}

// MARK: - Holding

struct Holding: Decodable {

    let symbol: String?
    let quantity: Int?
    let lastTradedPrice: Double?
    let averagePrice: Double?
    let closePrice: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        self.lastTradedPrice = try container.decodeIfPresent(Double.self, forKey: .lastTradedPrice)
        self.averagePrice = try container.decodeIfPresent(Double.self, forKey: .averagePrice)
        self.closePrice = try container.decodeIfPresent(Double.self, forKey: .closePrice)
    }

    enum CodingKeys: String, CodingKey {
        case symbol
        case quantity
        case lastTradedPrice = "ltp"
        case averagePrice = "avgPrice"
        case closePrice = "close"
    }
}

// MARK: - Computed Properties (Nil Safe)

extension Holding {
    
    var safeQuantity: Int {
        quantity ?? 0
    }

    var safeLTP: Double {
        lastTradedPrice ?? 0
    }

    var safeAveragePrice: Double {
        averagePrice ?? 0
    }

    var safeClosePrice: Double {
        closePrice ?? 0
    }

    var currentValue: Double {
        Double(safeQuantity) * safeLTP
    }

    var investedValue: Double {
        Double(safeQuantity) * safeAveragePrice
    }

    // Total PNL
    var profitOrLoss: Double {
        currentValue - investedValue
    }

    // Today's PNL
    var todaysProfitOrLoss: Double {
        (safeLTP - safeClosePrice) * Double(safeQuantity)
    }

    var profitOrLossPercentage: Double {
        guard investedValue != 0 else { return 0 }
        return (profitOrLoss / investedValue) * 100
    }

    var isProfit: Bool {
        profitOrLoss >= 0
    }
}

// MARK: - Portfolio Level Calculations

extension Array where Element == Holding {

    var totalCurrentValue: Double {
        reduce(0) { $0 + $1.currentValue }
    }

    var totalInvestment: Double {
        reduce(0) { $0 + $1.investedValue }
    }

    var overallProfitOrLoss: Double {
        totalCurrentValue - totalInvestment
    }

    var overallProfitOrLossPercentage: Double {
        guard totalInvestment != 0 else { return 0 }
        return (overallProfitOrLoss / totalInvestment) * 100
    }

    // Portfolio Today's PNL
    var todaysTotalProfitOrLoss: Double {
        reduce(0) { $0 + $1.todaysProfitOrLoss }
    }
}
