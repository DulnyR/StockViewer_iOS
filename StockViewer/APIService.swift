//
//  APIService.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//


import Foundation

class APIService {
    private let baseURL = "https://pro-api.coingecko.com/api/v3/"
    public static var coins: Dictionary<[String], [String]> = [:]
    
    static func obtainAllCoins(completion: @escaping (Result<Dictionary<[String], [String]>, Error>) -> Void) {
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
                
                let coins = Dictionary(uniqueKeysWithValues: coinsArray.map { coin in
                    (coin.id, coin.name)
                })
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume() 
    }

    /*
    func obtenerInfoPara(name: String, completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
        // Construir la URL con los parámetros necesarios
        let urlString = "\(baseURL)?latitude=\(latitud)&longitude=\(longitud)&daily=temperature_2m_max,precipitation_probability_max&timezone=Europe/Madrid"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        // Realizar la solicitud HTTP
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos no recibidos"])))
                return
            }

            do {
                // Decodificar la respuesta JSON
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Ajustar el formato de fecha según lo que devuelve la API
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                let respuesta = try decoder.decode(RespuestaOpenMeteo.self, from: data)
                var pronosticos = respuesta.daily.time.enumerated().map { (index, date) in
                    Prognostico(
                        fecha: date,
                        temp: respuesta.daily.temperature_2m_max[index],
                        probabilidadLluvia: respuesta.daily.precipitation_probability_max[index]
                    )
                    
                }
                
                
                // Ordenar los pronósticos por fecha
                pronosticos.sort(by: { $0.fecha < $1.fecha })
                print(pronosticos)
                
                completion(.success(pronosticos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
     */
}

struct CoinGeckoAnswer: Codable {
    let id: [String]
    let symbol: [String]
    let name: [String]
}

struct Coins: Codable {
    let id: [String]
    let symbol: [String]
    let name: [String]
}
