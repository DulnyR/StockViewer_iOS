//
//  Recommended.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation

struct Recommended {
    private var recommended: [CryptoCurrency]
    
    let bitcoinDescription = "Bitcoin is the first and most widely recognized cryptocurrency. It operates on a decentralized network powered by blockchain technology, ensuring transparency, security, and immutability of transactions. As a digital asset, Bitcoin is often seen as a store of value, akin to gold, and has become a popular choice for both investment and use in peer-to-peer transactions."
    let ethereumDescription = "Ethereum is often seen as a high-potential investment in the blockchain and cryptocurrency space, offering both growth opportunities and risk due to its widespread use in decentralized finance (DeFi) and smart contract applications. As the second-largest cryptocurrency by market capitalization, Ethereum's value is driven by its utility and adoption, with its native token, Ether (ETH), used to pay for transactions and computational services on the network."
    
    var bitcoin: CryptoCurrency
    var ethereum: CryptoCurrency
    
    //price hardcoded
    init() {
        bitcoin = CryptoCurrency(name: "Bitcoin", abbreviation: "BTC", currentPrice: 97.78)
        bitcoin.setDescription(content: bitcoinDescription)
        
        self.recommended = [bitcoin]
        
        ethereum = CryptoCurrency(name: "Ethereum", abbreviation: "ETH", currentPrice: 54.68)
        ethereum.setDescription(content: ethereumDescription)
        
        self.recommended.append(ethereum)
    }
    
    func getRecommended() -> [CryptoCurrency]{
        return recommended
    }
}
