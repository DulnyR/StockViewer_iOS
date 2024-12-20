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
    var euro: Bool
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: crypto.imageURL) { cryptoImage in
                    cryptoImage.resizable()
                } placeholder: {
                    Image(systemName: "dollarsign.ring")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .padding()
                }
                .frame(width: 32.0, height: 32.0)
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
                    crypto.updateDetails()
                }
                Spacer()
                if(euro) {
                    Text(CryptoModel.formatPrice(value: (crypto.currentPrice?["eur"]) ?? 0.00, euro: euro))
                        .foregroundColor(.gray)
                } else {
                    Text(CryptoModel.formatPrice(value: (crypto.currentPrice?["usd"]) ?? 0.00, euro: euro))
                        .foregroundColor(.gray)
                }
            }
            Text(crypto.content ?? "No description available.")
            Divider()
            WatchButton(crypto: crypto)
        }
    }
}
