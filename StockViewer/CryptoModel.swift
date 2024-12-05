//
//  Model.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation
import SwiftData

class CryptoModel {
    private static var coins: [String : CryptoCurrency] = [:]
    
    public static func loadCoins() {
        APIService.getAllCoins { result in
            switch result {
                case .success(let coins):
                CryptoModel.coins = coins
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }
    }
    
    public static func getFirstTenMatches(substring: String) -> [String] {
        if coins.isEmpty {
            loadCoins()
        }
        var matches = [String]()
        let coinArray = coins.keys
        
        for string in coinArray {
            if string.hasPrefix(substring) {
                matches.append(string)
            }
            
            if matches.count == 10 {
                break
            }
        }
        
        if matches.count < 10 {
            for string in coinArray {
                if string.contains(substring) && !matches.contains(string) {
                    matches.append(string)
                }

                if matches.count == 10 {
                    break
                }
            }
        }
        
        return matches
    }
    
    public static func getCoin(name: String) -> CryptoCurrency {
        if coins.isEmpty {
            loadCoins()
        }
        if let coin = coins[name] {
            return coin
        }
        return CryptoCurrency(name: name, APIid: "Unknown", symbol: "Unknown")
    }
}
