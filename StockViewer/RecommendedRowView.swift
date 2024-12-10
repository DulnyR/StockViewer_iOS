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
    var euro: Bool
    
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
            if (!currencies.contains(where: { $0.APIid == crypto.APIid })) {
                Button(action: {
                    addCrypto()
                }, label: {
                    HStack {
                        Text("**Watch**")
                        Image(systemName: "eye.fill")
                    }
                })
            } else {
                Button(action: {
                    deleteCrypto(crypto: crypto)
                }, label: {
                    HStack {
                        Text("**Unwatch**")
                        Image(systemName: "eye.slash")
                    }
                })
                .tint(.red)
            }
        }
    }
    
    func addCrypto() {
        withAnimation {
            modelContext.insert(crypto)
        }
    }
    
    func deleteCrypto(crypto: CryptoCurrency) {
        if let existingCrypto = currencies.first(where: { $0.APIid == crypto.APIid }) {
            withAnimation {
                modelContext.delete(existingCrypto)
            }
        }
    }
}
