//
//  YuniQuintero_BitcoinTrackerTests.swift
//  YuniQuintero-BitcoinTrackerTests
//
//  Created by Yuni Quintero on 4/12/25.
//

import XCTest
@testable import YuniQuintero_BitcoinTracker

final class YuniQuintero_BitcoinTrackerTests: XCTestCase {

    let mockedResult = PriceDetailResponse(
        marketData: CurrentPriceResponse(
            currentPrice: Price(eur: 5000, usd: 5500, gbp: 6000)
        )
    )

    @MainActor
    func testLoadDetailSuccess() async throws {
        let mockService = MockBitcoinPriceService(detailResult: .success(mockedResult))
        let viewModel = PriceListViewModel(service: mockService)
        let date = formDate(year: 2025, month: 12, day: 7)
        let item = PriceListItem(date: date, price: 4000)

        let response = await viewModel.loadDetail(for: item)

        XCTAssertNotNil(response)
        guard case .loadedDetail = viewModel.state else {
            XCTFail("Expected state loadedDetail, got \(viewModel.state)")
            return
        }
    }

    @MainActor
    func testLoadDetailFails() async throws {
        let mockService = MockBitcoinPriceService(detailResult: .failure(NetworkError.invalidURL))
        let viewModel = PriceListViewModel(service: mockService)
        let date = formDate(year: 2025, month: 12, day: 7)
        let item = PriceListItem(date: date, price: 4000)

        let response = await viewModel.loadDetail(for: item)

        XCTAssertNil(response)
        guard case .failed = viewModel.state else {
            XCTFail("Expected state failed, got \(viewModel.state)")
            return
        }
    }

    @MainActor
    func testDateFormattingHelpers() {
        let mockService = MockBitcoinPriceService(detailResult: .failure(NetworkError.invalidURL))
        let viewModel = PriceListViewModel(service: mockService)
        let date = formDate(year: 2025, month: 12, day: 7)

        XCTAssertEqual(viewModel.dateFormatter(date: date), "Dec 7, 2025")
        XCTAssertEqual(viewModel.dateFormatterForAPI(date: date), "2025-12-07")
    }

    private func formDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
    }
}
