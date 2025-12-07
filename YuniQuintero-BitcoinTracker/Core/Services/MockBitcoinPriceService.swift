//
//  MockBitcoinPriceService.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 7/12/25.
//

struct MockBitcoinPriceService: BitcoinPriceServiceProtocol {
    var detailResult: Result<PriceDetailResponse, Error>

    func getPriceList(vsCurrency: String, days: Int, interval: String) async throws -> PriceListResponse {
        return PriceListResponse(prices: [])
    }

    func getPriceDetail(date: String) async throws -> PriceDetailResponse {
        switch detailResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
