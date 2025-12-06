//
//  BitcoinPriceService.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 5/12/25.
//

import Foundation

protocol BitcoinPriceServiceProtocol {
    func getPriceList(vsCurrency: String, days: Int, interval: String) async throws -> PriceListResponse
    func getPriceDetail(date: String) async throws -> PriceDetailResponse
}

final class BitcoinPriceService: BitcoinPriceServiceProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getPriceList(vsCurrency: String, days: Int, interval: String) async throws -> PriceListResponse {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart") else {
            throw NetworkError.invalidURL
        }
        let params: [String: String] = [
            "vs_currency": vsCurrency,
            "days": String(days),
            "interval": interval
        ]

        return try await apiClient.get(url: url, params: params)
    }

    func getPriceDetail(date: String) async throws -> PriceDetailResponse {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin/history") else {
            throw NetworkError.invalidURL
        }
        let params: [String: String] = [
            "date": date
        ]

        return try await apiClient.get(url: url, params: params)
    }
}
