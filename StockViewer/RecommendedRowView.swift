//
//  RecommendedRowView.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import SwiftUI
import SwiftData

struct RecommendedRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currencies: [CryptoCurrency]
    var crypto: CryptoCurrency
    
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
                        Text(crypto.abbreviation)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                Spacer()
                Text("€\(crypto.currentPrice, specifier: "%.2f")")
                    .foregroundColor(.gray)
            }
            Text(crypto.content ?? "No description available.")
            Divider()
            Button(action: {
                addCrypto()
            }, label: {
                Text("**Watch**")
            })
        }
    }
    
    public func addCrypto() {
        withAnimation {
            let newCrypto = CryptoCurrency(name: crypto.name, abbreviation: crypto.abbreviation, currentPrice: crypto.currentPrice)
            modelContext.insert(newCrypto)
        }
    }
}
