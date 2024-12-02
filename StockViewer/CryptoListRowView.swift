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
    
    var body: some View {
        NavigationLink {
            Text("Details for \(crypto.name)")
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
                        Text(crypto.abbreviation)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                Spacer()
                if(euro) {
                    Text("€\(crypto.currentEuroPrice, specifier: "%.2f")")
                        .foregroundColor(.gray)
                } else {
                    Text("$\(crypto.currentDollarPrice, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
