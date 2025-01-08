//
//  CryptoViewModel.swift
//  StockViewer
//
//  Created by Radek Dulny on 26/12/24.
//

import Foundation

class CryptoViewModel: ObservableObject {
    private let model: CryptoModel
    
    init() {
        self.model = CryptoModel()
    }
    
    public func loadCoins() {
        model.loadCoins()
    }
    
    // gets first ten matches of coins (used for search functionality)
    public func getFirstTenMatches(substring: String) -> [CryptoCurrency] {
        let coins = model.getCoins()
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
    
    public func getCoin(name: String) -> CryptoCurrency {
        return model.getCoin(name: name)
    }
    
    public func isEuro() -> Bool {
        return model.isEuro()
    }
    
    public func setEuro(euro: Bool) {
        model.setEuro(euro: euro)
    }
    
    public func getViewables() -> [String: Bool] {
        return model.getViewables()
    }
    
    public func setViewables(viewables: [String: Bool]) {
        model.setViewables(viewables: viewables)
    }
    
    func setPriceAlarm(crypto: CryptoCurrency, price: Double, increase: Bool) {
        NotificationManager.shared.startMonitoringPrice(crypto: crypto, price: price, increase: increase, euro: isEuro())
    }
    
    func setPercentageChangeAlarm(crypto: CryptoCurrency, price: Double, percentage: Double) {
        NotificationManager.shared.startMonitoringPercentage(crypto: crypto, price: price, percentage: percentage, euro: isEuro())
    }
    
    func getRecommended() -> [CryptoCurrency] {
        return model.getRecommended()
    }
}
