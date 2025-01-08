//
//  CryptoAlert.swift
//  StockViewer
//
//  Created by Radek Dulny on 16/12/24.
//

import Foundation
import SwiftData

@Model
class CryptoAlert {
    @Attribute var id: UUID
    @Attribute var cryptoName: String
    @Attribute var targetPrice: Double
    @Attribute var percentage: Double?
    @Attribute var dateCreated: Date
    @Attribute var euro: Bool = true
    
    // initialiser for percentage alerts
    init(id: UUID = UUID(), cryptoName: String, currentPrice: Double, percentage: Double, dateCreated: Date = Date(), euro: Bool) {
        self.id = id
        self.cryptoName = cryptoName
        self.targetPrice = currentPrice * (1 + (percentage / 100))
        self.percentage = percentage
        self.dateCreated = dateCreated
        self.euro = euro
    }
    
    // initialiser for price alerts
    init(id: UUID = UUID(), cryptoName: String, targetPrice: Double, dateCreated: Date = Date(), euro: Bool) {
        self.id = id
        self.cryptoName = cryptoName
        self.targetPrice = targetPrice
        self.dateCreated = dateCreated
        self.euro = euro
    }
}
