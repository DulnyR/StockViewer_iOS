//
//  CryptoCurrency.swift
//  StockViewer
//
//  Created by alumno on 29/11/24.
//

import Foundation
import SwiftData

@Model
class CryptoCurrency {
    @Attribute var id: UUID
    @Attribute var name: String
    @Attribute var APIid: String
    @Attribute var content: String?
    @Attribute var symbol: String
    @Attribute var eurPrice: Double?
    @Attribute var usdPrice: Double?
    
    init(name: String, APIid: String, symbol: String) {
        self.id = UUID()
        self.name = name
        self.APIid = APIid
        self.symbol = symbol
    }

    func updatePrices() {
        APIService.getPrice(currency: self.APIid, currency: "EUR") { result in
            switch result {
                case .success(let price):
                self.eurPrice = price
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }

        APIService.getPrice(currency: self.APIid, currency: "USD") { result in
            switch result {
                case .success(let price):
                self.usdPrice = price
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }
    }
    
    func setDescription(content : String) {
        self.content = content
    }
}
