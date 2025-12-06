//
//  ContentView.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 4/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PriceListView(viewModel: PriceListViewModel(service: BitcoinPriceService(apiClient: APIClient())))
    }
}

