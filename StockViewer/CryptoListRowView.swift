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
    // Save API Calls
    var showPrice: Bool
    
    var body: some View {
        NavigationLink {
            CryptoDetailView(crypto: crypto)
        } label: {
            HStack {
                Image(systemName: "bitcoinsign.circle")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                    .padding()
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
                    if(euro) {
                        Text("€\(crypto.eurPrice ?? 0.00, specifier: "%.2f")")
                            .foregroundColor(.gray)
                    } else {
                        Text("$\(crypto.usdPrice ?? 0.00, specifier: "%.2f")")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
