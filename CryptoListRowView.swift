//
//  CryptoListRowView.swift
//  StockViewer
//
//  Created by alumno on 29/11/24.
//

import SwiftUI

struct CryptoListRowView: View {
    var crypto: CryptoCurrency
    var euro: Bool
    var showPrice: Bool = true
    
    var body: some View {
        NavigationLink {
            CryptoDetailView(crypto: crypto)
        } label: {
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
                            .font(.headline)
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
                        Text(CryptoModel.formatPrice(value: (crypto.currentPrice?["eur"])!, euro: euro))
                            .foregroundColor(.gray)
                    } else {
                        Text(CryptoModel.formatPrice(value: (crypto.currentPrice?["usd"])!, euro: euro))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
