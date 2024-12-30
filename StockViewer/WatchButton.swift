//
//  WatchButton.swift
//  StockViewer
//
//  Created by alumno on 11/12/24.
//

import SwiftUI
import SwiftData

struct WatchButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currencies: [CryptoCurrency]
    var crypto: CryptoCurrency
    
    var body: some View {
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
