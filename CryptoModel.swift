//
//  Model.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation
import SwiftData

class CryptoModel {
    public static var coins: [String : CryptoCurrency] = [:]
    
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
    
    public static func getFirstTenMatches(substring: String) -> [CryptoCurrency] {
        if coins.isEmpty {
            loadCoins()
        }
        let substring = substring.lowercased().replacingOccurrences(of: " ", with: "-")
        var matches = [CryptoCurrency]()
        var foundStrings = Set<String>()
        let coinArray = coins.keys
        
        for string in coinArray {
            let string = string.lowercased()
            if string.hasPrefix(substring) {
                matches.append(coins[string]!)
                foundStrings.insert(string)
            }
            
            if matches.count == 10 {
                break
            }
        }
        
        if matches.count < 10 {
            for string in coinArray {
                let string = string.lowercased()
                if string.contains(substring) && !foundStrings.contains(string) {
                    matches.append(coins[string]!)
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
    
    public static func isEuro() -> Bool {
        return UserDefaults.standard.bool(forKey: "euro")
    }
    
    public static func formatPrice(value: Double, euro: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = euro ? "EUR" : "USD"
        formatter.currencySymbol = euro ? "€" : "$"
        formatter.locale = Locale(identifier: "en_US")
        var digits = 6
        if value > 1000000 {
            digits = 0
        } else if value > 10 {
            digits = 2
        }
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
