//
//  Model.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation
import SwiftData

class CryptoModel {
    private static var currencyIds: [String : String] = [:]
    
    init() {
        APIService.obtainAllCoins { result in
            switch result {
                case .success(let coins):
                CryptoModel.currencyIds = coins
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }
    }
    
    public static func getFirstTenMatches(substring: String) -> [String] {
        var matches = [String]()
        var coinArray = currencyIds.keys
            
        for string in coinArray {
            if string.contains(substring) {
                matches.append(string)
            }
            
            if matches.count == 10 {
                break
            }
        }
        
        return matches
    }
    
    public static func getCoinId(name: String) -> String {
        if let id = currencyIds[name] {
            return id
        }
        return ""
    }
}
