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
                ForEach(currencies) { currency in
                    CryptoListRowView(crypto: currency, euro: euro)
                }
                .onDelete(perform: deleteCrypto)
            }
            .onAppear {
                CryptoModel.loadCoins()
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
                        euro.toggle()
                    }, label: {
                        euro ? Text("**EUR €**") : Text("**USD $**")
                    })
                }
            }
        }
        .tint(Color.green)
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
