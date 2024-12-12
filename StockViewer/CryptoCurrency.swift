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
    var eurPrice: Double?
    var usdPrice: Double?
    var image: URL?
    
    
    init(name: String, APIid: String, symbol: String) {
        self.id = UUID()
        self.name = name
        self.APIid = APIid
        self.symbol = symbol
    }

    func updateDetails() {
        APIService.getEURPrice(coinId: self.APIid) { result in
            switch result {
                case .success(let price):
                DispatchQueue.main.async {
                    self.eurPrice = price.eur
                }
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }

        APIService.getUSDPrice(coinId: self.APIid) { result in
            switch result {
                case .success(let price):
                DispatchQueue.main.async {
                    self.usdPrice = price.usd
                }
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }
        
        APIService.getDetails(coinId: self.APIid) { result in
            switch result {
                case .success (let data):
                DispatchQueue.main.async {
                    self.eurPrice = data.market_data.current_price["eur"]
                    self.usdPrice = data.market_data.current_price["usd"]
                    self.image = data.image
                }
                
                case .failure(let error):
                    print("Error:", error)
            }
        }
    }
    
    func setDescription(content : String) {
        self.content = content
    }
}
