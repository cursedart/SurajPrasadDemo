//
//  Holding.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation

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

extension Holding {
    init(
        symbol: String?,
        quantity: Int?,
        lastTradedPrice: Double?,
        averagePrice: Double?,
        closePrice: Double?
    ) {
        self.symbol = symbol
        self.quantity = quantity
        self.lastTradedPrice = lastTradedPrice
        self.averagePrice = averagePrice
        self.closePrice = closePrice
    }
}
