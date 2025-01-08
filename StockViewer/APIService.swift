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
    
    // get basic info about all coins
    public static func getAllCoins(completion: @escaping (Result<Dictionary<String, CryptoCurrency>, Error>) -> Void) {
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
    
    // get all details for given coin
    public static func getDetails(coinId: String, completion: @escaping (Result<CoinData, Error>) -> Void) {
        let urlString = baseURL + "coins/" + coinId + "?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false&" + apiKey
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(CoinData.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
    
        task.resume()
    }
    
    // get historical prices for given coin
    public static func getHistoricalPrices(coinId: String, currency: String, days: Int, completion: @escaping (Result<[Price], Error>) -> Void) {
        var components = URLComponents(string: baseURL + "coins/\(coinId)/market_chart")!
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: currency),
            URLQueryItem(name: "days", value: String(days)),
            URLQueryItem(name: "api_key", value: apiKey)
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

// API structs
struct CoinGeckoCoin: Codable {
    let id: String
    let symbol: String
    let name: String
}

struct HistoricalPrices: Decodable {
    let prices: [[Double]]
}

struct Price: Decodable {
    let timestamp: Int
    let value: Double
}

struct CoinData: Codable {
    let image: ImageURLs
    let description: [String: String]
    let market_data: MarketData
}

struct ImageURLs: Codable {
    let thumb: String?
    let small: String?
    let large: String?
}

struct MarketData: Codable {
    let current_price: [String: Double]
    let market_cap_rank: Int?
    let market_cap: [String: Double]?
    let total_volume: [String: Double]?
    let total_supply: Double?
    let high_24h: [String: Double]?
    let low_24h: [String: Double]?
}


