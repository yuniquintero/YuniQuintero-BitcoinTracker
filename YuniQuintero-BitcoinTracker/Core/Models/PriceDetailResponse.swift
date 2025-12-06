//
//  PriceDetailResponse.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 5/12/25.
//

import Foundation

struct Price: Codable {
    var eur: Double
    var usd: Double
    var gbp: Double
}

struct CurrentPriceResponse: Codable {
    var currentPrice: Price

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
    }
}

struct PriceDetailResponse: Codable {
    var marketData: CurrentPriceResponse

    enum CodingKeys: String, CodingKey {
        case marketData = "market_data"
    }
}
