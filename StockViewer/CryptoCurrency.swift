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
    var isFavorite: Bool = false
    var currentPrice: [String: Double]?
    var marketCapRank: Int?
    var marketCap: [String: Double]?
    var totalVolume: [String: Double]?
    var imageURL: URL?
    var coinDescription: String?
    var totalSupply: Double?
    var high24h: [String: Double]?
    var low24h: [String: Double]?
    
    init(name: String, APIid: String, symbol: String) {
        self.id = UUID()
        self.name = name
        self.APIid = APIid
        self.symbol = symbol
    }

    // fetches most current data about the coin from the API
    func updateDetails() {
        APIService.getDetails(coinId: self.APIid) { result in
            switch result {
                case .success (let data):
                DispatchQueue.main.async {
                    self.currentPrice = data.market_data.current_price
                    self.marketCapRank = data.market_data.market_cap_rank
                    self.marketCap = data.market_data.market_cap
                    self.totalVolume = data.market_data.total_volume
                    self.totalSupply = data.market_data.total_supply
                    self.high24h = data.market_data.high_24h
                    self.low24h = data.market_data.low_24h
                    if let urlString = data.image.small {
                        self.imageURL = URL(string: urlString)
                    }
                    self.coinDescription = data.description["en"]
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
