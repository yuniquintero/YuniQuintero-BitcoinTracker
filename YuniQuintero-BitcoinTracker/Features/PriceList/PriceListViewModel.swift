//
//  PriceListViewModel.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 4/12/25.
//

import Foundation

@MainActor
final class PriceListViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded([PriceListItem])
        case loadedDetail(PriceDetailResponse)
        case failed(String)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle),
                 (.loading, .loading),
                 (.loaded, .loaded),
                 (.loadedDetail, .loadedDetail),
                 (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }

    @Published private(set) var state: State = .idle
    private let service: BitcoinPriceServiceProtocol
    private let days: Int = 14
    private let vsCurrency: String = "usd"
    private let interval: String = "daily"
    @Published var priceItems: [PriceListItem] = []

    init(service: BitcoinPriceServiceProtocol) {
        self.service = service
    }

    func loadHistory() async {
        guard case .idle = state else { return }
        state = .loading

        do {
            let response = try await service.getPriceList(vsCurrency: vsCurrency, days: days, interval: interval)
            var items = mapListItems(response: response)
            items.removeFirst()
            priceItems = items
            state = .loaded(items)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func retry() async {
        state = .idle
        await loadHistory()
    }

    func loadDetail(for item: PriceListItem) async -> PriceDetailResponse? {
        do {
            state = .loading
            let formattedDate = dateFormatterForAPI(date: item.date)
            let response = try await service.getPriceDetail(date: formattedDate)
            state = .loadedDetail(response)
            return response
        } catch {
            state = .failed(error.localizedDescription)
            return nil
        }
    }

    private func mapListItems(response: PriceListResponse) -> [PriceListItem] {
        return response.prices.compactMap { entry in
            guard entry.count == 2 else { return nil }

            let unixDate = entry[0] / 1000.0
            let price = entry[1]

            let date  = Date(timeIntervalSince1970: unixDate)
            return PriceListItem(date: date, price: price)
        }
        .sorted(by: {$0.date > $1.date})
    }

    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    func dateFormatterForAPI(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func roundPrice(value: Double) -> String {
        String(format: "$ %.2f", value)
    }
}
