//
//  RecommendedRowView.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import SwiftUI
import SwiftData

struct RecommendedRowView: View {
    var crypto: CryptoCurrency
    @State var euro: Bool
    
    var body: some View {
        VStack {
            HStack {
                //image hardcoded
                Image(systemName: "bitcoinsign.circle")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                    .padding()
                VStack {
                    HStack {
                        Text(crypto.name)
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Text(crypto.symbol)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                .onAppear {
                    crypto.updatePrices()
                }
                Spacer()
                if(euro) {
                    Text("€\(crypto.eurPrice ?? 0.00, specifier: "%.2f")")
                        .foregroundColor(.gray)
                } else {
                    Text("$\(crypto.usdPrice ?? 0.00, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
            Text(crypto.content ?? "No description available.")
            Divider()
            WatchButton(crypto: crypto)
        }
    }
}
