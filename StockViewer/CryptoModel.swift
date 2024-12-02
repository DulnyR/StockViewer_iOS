//
//  Model.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation
import SwiftData

class CryptoModel {
    private var modelContext: ModelContext
    private var currencies: [CryptoCurrency]
    
    init(modelContext: ModelContext, currencies: [CryptoCurrency]) {
            self.modelContext = modelContext
            self.currencies = currencies
    }
    
    public func addCoin(coin: CryptoCurrency) {
        modelContext.insert(coin)
    }
    
    public func deleteCoin(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(currencies[index])
        }
    }
    
    public func getCurrencies() -> [CryptoCurrency] {
        return currencies
    }
}
