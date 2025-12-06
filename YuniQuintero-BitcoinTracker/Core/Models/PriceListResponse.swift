//
//  PriceListResponse.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 5/12/25.
//

import Foundation

struct PriceListResponse: Codable {
    var prices: [[Double]]
}

struct PriceListItem: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
