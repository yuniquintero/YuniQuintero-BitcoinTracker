//
//  PriceDetailViewModel.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 6/12/25.
//

import Foundation

struct PriceDetailViewModel {
    let date: Date
    let detail: PriceDetailResponse

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    var usdPrice: Double { detail.marketData.currentPrice.usd }
    var eurPrice: Double { detail.marketData.currentPrice.eur }
    var gbpPrice: Double { detail.marketData.currentPrice.gbp }
}
