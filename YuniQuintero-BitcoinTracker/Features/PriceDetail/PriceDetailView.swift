//
//  PriceDetailView.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 6/12/25.
//

import SwiftUI

struct PriceDetailView: View {
    let viewModel: PriceDetailViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.formattedDate)
                .font(.headline)

            VStack(spacing: 12) {
                priceRow(title: "USD", value: viewModel.usdPrice, symbol: "$")
                priceRow(title: "EUR", value: viewModel.eurPrice, symbol: "€")
                priceRow(title: "GBP", value: viewModel.gbpPrice, symbol: "£")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .navigationTitle("Bitcoin Price Details")
    }

    private func priceRow(title: String, value: Double, symbol: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(String(format: "%@ %.2f", symbol, value))
                .font(.body.bold())
        }
    }
}
