//
//  PriceRowView.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 6/12/25.
//

import SwiftUI

struct PriceRowView: View {
    let date: String
    let price: String

    var body: some View {
        HStack {
            Text(date)
            Spacer()
            Text(price)
        }
        .padding(.vertical, 8)
    }
}
