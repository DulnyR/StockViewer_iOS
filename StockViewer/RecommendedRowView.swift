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
    @State private var clicked = false
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
                Spacer()
                if(euro) {
                    Text("€\(crypto.currentEuroPrice, specifier: "%.2f")")
                        .foregroundColor(.gray)
                } else {
                    Text("$\(crypto.currentDollarPrice, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
            Text(crypto.content ?? "No description available.")
            Divider()
            if (!clicked) {
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
                    deleteCrypto()
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
    
    public func addCrypto() {
        withAnimation {
            clicked = true
            modelContext.insert(crypto)
        }
    }
    
    public func deleteCrypto() {
        withAnimation {
            clicked = false
            modelContext.delete(crypto)
        }
    }
}
