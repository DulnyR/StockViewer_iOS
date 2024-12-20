//
//  CryptoAlert.swift
//  StockViewer
//
//  Created by Inna Castro on 16/12/24.
//

import Foundation
import SwiftData

@Model
class CryptoAlert {
    var id: UUID
    var cryptoName: String
    var targetPrice: Double
    var percentage: Double?
    var dateCreated: Date
    
    init(id: UUID = UUID(), cryptoName: String, targetPrice: Double, percentage: Double, dateCreated: Date = Date()) {
        self.id = id
        self.cryptoName = cryptoName
        self.targetPrice = targetPrice
        self.percentage = percentage
        self.dateCreated = dateCreated
    }
    
    init(id: UUID = UUID(), cryptoName: String, targetPrice: Double, dateCreated: Date = Date()) {
        self.id = id
        self.cryptoName = cryptoName
        self.targetPrice = targetPrice
        self.dateCreated = dateCreated
    }
}
