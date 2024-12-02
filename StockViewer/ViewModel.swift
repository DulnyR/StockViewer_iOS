//
//  ViewModel.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import SwiftUI
import SwiftData

class ViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Query private var currencies: [CryptoCurrency]
    
    private var cryptoModel: CryptoModel
    
    init(modelContext: ModelContext, currencies: [CryptoCurrency]) {
        self.modelContext = modelContext
        self.cryptoModel = CryptoModel(modelContext: modelContext, currencies: currencies)
    }
    
    func addCoin(coin: CryptoCurrency) {
        cryptoModel.addCoin(coin: coin)
    }
    
    func deleteCoin(offsets: IndexSet) {
        cryptoModel.deleteCoin(offsets: offsets)
    }
    
    func getCurrencies() -> [CryptoCurrency] {
        return cryptoModel.getCurrencies()
    }
}
