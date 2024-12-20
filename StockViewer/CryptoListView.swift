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
    @State private var euro: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedCurrencies) { currency in
                    CryptoListRowView(crypto: currency, euro: euro)
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            toggleFavorite(for: currency)
                        }) {
                            Label(
                                currency.isFavorite ? "Unfavorite" : "Favorite",
                                systemImage: currency.isFavorite ? "star.slash.fill" : "star"
                            )
                        }
                        .tint(currency.isFavorite ? .gray : .yellow)
                    }
                }
                .onDelete(perform: deleteCrypto)
            }
            .onAppear {
                euro = CryptoModel.isEuro()
                DispatchQueue.main.async {
                    CryptoModel.loadCoins()
                    for currency in currencies {
                        currency.updateDetails()
                    }
                }
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
                    EuroToggle(euro: $euro)
                }
            }
        }
        .tint(Color.green)
    }
    
    private var sortedCurrencies: [CryptoCurrency] {
        currencies.sorted {
            if $0.isFavorite == $1.isFavorite {
                return $0.name < $1.name
            }
            return $0.isFavorite && !$1.isFavorite 
        }
    }

    private func toggleFavorite(for currency: CryptoCurrency) {
        withAnimation {
            currency.isFavorite.toggle()
            try? modelContext.save()
        }
    }

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
