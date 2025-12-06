//
//  PriceListView.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 4/12/25.
//

import SwiftUI

struct PriceListView: View {

    @StateObject var viewModel: PriceListViewModel
    @State private var selectedDate: Date? = nil
    @State private var navigate = false
    @State private var priceDetail: PriceDetailResponse?
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List(viewModel.priceItems) { item in
                        Button {
                            Task { @MainActor in
                                selectedDate = item.date

                                guard let response = await viewModel.loadDetail(for: item) else { return }
                                priceDetail = response
                                navigate = true
                            }
                        } label: {
                            HStack {
                                Text(viewModel.dateFormatter(date: item.date))
                                Spacer()
                                Text(viewModel.roundPrice(value: item.price))
                            }
                        }
                    }
                    .disabled(isLoading)

                    NavigationLink(
                        destination: Group {
                            if let selectedDate = selectedDate, let priceDetail = priceDetail {
                                PriceDetailView(
                                    viewModel: PriceDetailViewModel(
                                        date: selectedDate,
                                        detail: priceDetail
                                    )
                                )
                            } else {
                                EmptyView()
                            }
                        },
                        isActive: $navigate
                    ) {
                        EmptyView()
                    }
                }
                if isLoading {
                    Color.black.opacity(0.15)
                        .ignoresSafeArea()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .task {
                await viewModel.loadHistory()
            }
            .onChange(of: viewModel.state) { state in
                guard case .failed(let message) = state else { return }
                errorMessage = message
                showError = true
            }
            .alert("Error", isPresented: $showError) {
                Button("Retry") {
                    Task {
                        await viewModel.retry()
                    }
                }
                Button("Dismiss", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .navigationTitle("Bitcoin Price History")
        }
    }

    private var isLoading: Bool {
        if case .loading = viewModel.state { return true }
        return false
    }
}
