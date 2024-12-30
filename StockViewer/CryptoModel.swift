//
//  Model.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation
import SwiftData

class CryptoModel {
    // coins keeps track of all coins that have been downloaded from the API
    private var coins: [String : CryptoCurrency] = [:]
    private var recommended: [CryptoCurrency] = []
    
    init() {
        loadCoins()
        setRecommended()
    }
    
    // this function loads the most recent coins from the API
    public func loadCoins() {
        APIService.getAllCoins { result in
            switch result {
                case .success(let coins):
                self.coins = coins
                    
                case .failure(let error):
                    print("Error:", error)
                }
        }
    }
    
    // custom coin recommendations
    private func setRecommended() {
        let bitcoinDescription = "Bitcoin is the first and most widely recognized cryptocurrency. It operates on a decentralized network powered by blockchain technology, ensuring transparency, security, and immutability of transactions. As a digital asset, Bitcoin is often seen as a store of value, akin to gold, and has become a popular choice for both investment and use in peer-to-peer transactions."
        let ethereumDescription = "Ethereum is often seen as a high-potential investment in the blockchain and cryptocurrency space, offering both growth opportunities and risk due to its widespread use in decentralized finance (DeFi) and smart contract applications. As the second-largest cryptocurrency by market capitalization, Ethereum's value is driven by its utility and adoption, with its native token, Ether (ETH), used to pay for transactions and computational services on the network."
        let solanaDescription = "Solana is a high-performance blockchain known for its fast transaction speeds and low fees, making it an attractive option for decentralized applications and DeFi projects. With strong developer support and a growing ecosystem, it presents significant potential for long-term growth and adoption in the blockchain space."
        
        var bitcoin = getCoin(name: "bitcoin")
        bitcoin.setDescription(content: bitcoinDescription)
        bitcoin.updateDetails()
        
        self.recommended = [bitcoin]
        
        var ethereum = getCoin(name: "ethereum")
        ethereum.setDescription(content: ethereumDescription)
        ethereum.updateDetails()
        
        self.recommended.append(ethereum)
        
        var solana = getCoin(name: "solana")
        solana.setDescription(content: solanaDescription)
        solana.updateDetails()
        
        self.recommended.append(solana)
    }
    
    public func getCoins() -> [String : CryptoCurrency] {
        if coins.isEmpty {
            loadCoins()
        }
        return coins
    }
    
    // allows to get the coin needed by its name
    public func getCoin(name: String) -> CryptoCurrency {
        if coins.isEmpty {
            loadCoins()
        }
        if let coin = coins[name] {
            return coin
        }
        return CryptoCurrency(name: name, APIid: "Unknown", symbol: "Unknown")
    }
    
    public func isEuro() -> Bool {
        return UserDefaults.standard.bool(forKey: "euro")
    }
    
    public func setEuro(euro: Bool) {
        UserDefaults.standard.set(euro, forKey: "euro")
    }
    
    // gets stats that should be seen by user and makes all seen in case of any errors
    public func getViewables() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: "viewables") as? [String: Bool] ?? [
            "rank": true,
            "24hHigh": true,
            "24hLow": true,
            "marketCap": true,
            "volume": true,
            "supply": true,
            "description": true
        ]
    }
    
    public func setViewables(viewables: [String: Bool]) {
        UserDefaults.standard.set(viewables, forKey: "viewables")
    }
    
    public func getRecommended() -> [CryptoCurrency] {
        return recommended
    }
}
