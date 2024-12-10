//
//  APIService.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//


import Foundation

class APIService {
    private static let baseURL = "https://api.coingecko.com/api/v3/"
    private static let apiKey = "x_cg_demo_api_key=CG-pViMt2LYb6PkMtzC49LgBT1U"
    
    public static func getAllCoins(completion: @escaping (Result<Dictionary<String, CryptoCurrency>, Error>) -> Void) {
        //var coins: Dictionary<String, CryptoCurrency> = [:]
        let urlString = baseURL + "coins/list?" + apiKey
        
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
                let coinsArray = try decoder.decode([CoinGeckoCoin].self, from: data)
                var seenNames: Set<String> = []
                
                let coins = Dictionary(uniqueKeysWithValues: coinsArray.compactMap { coin in
                    if !seenNames.contains(coin.name) {
                        seenNames.insert(coin.name)
                        return (coin.id, CryptoCurrency(name: coin.name, APIid: coin.id, symbol: coin.symbol))
                    } else {
                        return nil
                    }
                })
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume() 
    }
    
    public static func getUSDPrice(coinId: String, completion: @escaping (Result<CoinUSDPrice, Error>) -> Void) {
        let urlString = baseURL + "simple/price?ids=" + coinId + "&vs_currencies=usd&" + apiKey
        
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
                // Decode the response into a dictionary where the key is the coinId
                let decodedData = try JSONDecoder().decode([String: CoinUSDPrice].self, from: data)
                
                // Check if the coinId exists in the decoded data
                if let coinData = decodedData[coinId] {
                    completion(.success(coinData))  // Return the CoinPrice for the requested coinId
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Coin not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public static func getEURPrice(coinId: String, completion: @escaping (Result<CoinEURPrice, Error>) -> Void) {
        let urlString = baseURL + "simple/price?ids=" + coinId + "&vs_currencies=eur&" + apiKey
        
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
                // Decode the response into a dictionary where the key is the coinId
                let decodedData = try JSONDecoder().decode([String: CoinEURPrice].self, from: data)
                
                // Check if the coinId exists in the decoded data
                if let coinData = decodedData[coinId] {
                    completion(.success(coinData))  // Return the CoinPrice for the requested coinId
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Coin not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public static func getHistoricalPrices(coinId: String, currency: String, days: Int, completion: @escaping (Result<[Price], Error>) -> Void) {
        var components = URLComponents(string: baseURL + "coins/\(coinId)/market_chart")!
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: currency),
            URLQueryItem(name: "days", value: String(days)),
            URLQueryItem(name: "api_key", value: apiKey) // Assuming the API key is passed as a query parameter
        ]
        
        guard let url = components.url else {
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
                let decodedData = try JSONDecoder().decode(HistoricalPrices.self, from: data)
                let prices = decodedData.prices.map { array in
                    Price(timestamp: Int(array[0]), value: array[1])
                }
                completion(.success(prices))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }


 }

struct CoinGeckoCoin: Codable {
    let id: String
    let symbol: String
    let name: String
}

struct CoinUSDPrice: Decodable {
    let usd: Double
}

struct CoinEURPrice: Decodable {
    let eur: Double
}

struct HistoricalPrices: Decodable {
    let prices: [[Double]]
}

struct Price: Decodable {
    let timestamp: Int
    let value: Double
}


