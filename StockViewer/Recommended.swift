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
    let solanaDescription = "Solana is a high-performance blockchain known for its fast transaction speeds and low fees, making it an attractive option for decentralized applications and DeFi projects. With strong developer support and a growing ecosystem, it presents significant potential for long-term growth and adoption in the blockchain space."
    
    var bitcoin: CryptoCurrency
    var ethereum: CryptoCurrency
    var solana: CryptoCurrency
    
    init() {
        bitcoin = CryptoModel.getCoin(name: "bitcoin")
        bitcoin.setDescription(content: bitcoinDescription)
        bitcoin.updateDetails()
        
        self.recommended = [bitcoin]
        
        ethereum = CryptoModel.getCoin(name: "ethereum")
        ethereum.setDescription(content: ethereumDescription)
        ethereum.updateDetails()
        
        self.recommended.append(ethereum)
        
        solana = CryptoModel.getCoin(name: "solana")
        solana.setDescription(content: solanaDescription)
        solana.updateDetails()
        
        self.recommended.append(solana)
    }
    
    func getRecommended() -> [CryptoCurrency]{
        return recommended
    }
}
