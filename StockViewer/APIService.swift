//
//  APIService.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//


import Foundation

class APIService {
    private let baseURL = "https://pro-api.coingecko.com/api/v3/"
    public static var coins: Dictionary<String, String> = [:]
    
    static func obtainAllCoins(completion: @escaping (Result<Dictionary<String, String>, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/list?x_cg_demo_api_key=CG-pViMt2LYb6PkMtzC49LgBT1U"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let coinsArray = try decoder.decode([CoinGeckoAnswer].self, from: data)
                var seenNames: Set<String> = []
                
                let coins = Dictionary(uniqueKeysWithValues: coinsArray.compactMap { coin in
                    if !seenNames.contains(coin.name) {
                        seenNames.insert(coin.name)
                        return (coin.name, coin.id)
                    } else {
                        return nil // Skip duplicates
                    }
                })
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume() 
    }
}

struct CoinGeckoAnswer: Codable {
    let id: String
    let symbol: String
    let name: String
}
