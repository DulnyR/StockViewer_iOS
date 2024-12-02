//
//  CryptoCurrency.swift
//  StockViewer
//
//  Created by alumno on 29/11/24.
//

import Foundation
import SwiftData

@Model
class CryptoCurrency {
    @Attribute var id: UUID
    @Attribute var name: String
    @Attribute var content: String?
    @Attribute var abbreviation: String
    @Attribute var currentEuroPrice: Double
    @Attribute var currentDollarPrice: Double
    
    init(name: String, abbreviation: String, currentEuroPrice: Double, currentDollarPrice: Double) {
        self.id = UUID()
        self.name = name
        self.abbreviation = abbreviation
        self.currentEuroPrice = currentEuroPrice
        self.currentDollarPrice = currentDollarPrice
    }
    
    func setDescription(content : String) {
        self.content = content
    }
}
