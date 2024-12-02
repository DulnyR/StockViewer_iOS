//
//  CryptoListView.swift
//  StockViewer
//
//  Created by alumno on 29/11/24.
//

import SwiftUI
import SwiftData

struct CryptoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currencies: [CryptoCurrency]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(currencies) { currency in
                    CryptoListRowView(crypto: currency)
                }
                .onDelete(perform: deleteCrypto)
            }
            .navigationTitle("My Coins")
            .overlay {
                if currencies.isEmpty {
                    ContentUnavailableView {
                        Label("No coins are being watched", systemImage: "doc.text.magnifyingglass")
                    } description: {
                        Text("Add new coins in the Explore tab below")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        print("currency changed")
                    }, label: {
                        Text("**USD/EUR**")
                    })
                }
            }
        }
        .tint(Color.green)
    }
    
    /*
    public func addCrypto() {
        withAnimation {
            let newCrypto = CryptoCurrency(name: "Bitcoin", abbreviation: "BTC", currentPrice: 99.78)
            modelContext.insert(newCrypto)
        }
    }
     */

    private func deleteCrypto(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(currencies[index])
            }
        }
    }
}

#Preview {
    CryptoListView()
        .modelContainer(for: CryptoCurrency.self, inMemory: true)
}
