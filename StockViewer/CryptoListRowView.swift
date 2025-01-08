//
//  CryptoListRowView.swift
//  StockViewer
//
//  Created by alumno on 29/11/24.
//

import SwiftUI

// shows every row in a list of coins
struct CryptoListRowView: View {
    @StateObject var viewModel: CryptoViewModel
    var crypto: CryptoCurrency
    var euro: Bool
    var showPrice: Bool = true
    
    var body: some View {
        NavigationLink {
            CryptoDetailView(viewModel: viewModel, crypto: crypto)
        } label: {
            HStack {
                AsyncImage(url: crypto.imageURL) { cryptoImage in
                    cryptoImage.resizable()
                } placeholder: {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .padding()
                }
                .frame(width: 32.0, height: 32.0)
                
                VStack {
                    HStack {
                        Text(crypto.name)
                            .font(.headline)
                        if crypto.isFavorite {
                            Image(systemName: "star.fill")
                        }
                        Spacer()
                    }
                    HStack {
                        Text(crypto.symbol)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                Spacer()
                if (showPrice) {
                    if (euro) {
                        Text(PriceFormatter.formatPrice(value: crypto.currentPrice?["eur"] ?? 0, euro: euro))
                            .foregroundColor(.gray)
                    } else {
                        Text(PriceFormatter.formatPrice(value: crypto.currentPrice?["usd"] ?? 0, euro: euro))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
