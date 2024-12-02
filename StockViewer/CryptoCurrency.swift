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
    @Attribute var currentPrice: Double
    
    init(name: String, abbreviation: String, currentPrice: Double) {
        self.id = UUID()
        self.name = name
        self.abbreviation = abbreviation
        self.currentPrice = currentPrice
    }
    
    func setDescription(content : String) {
        self.content = content
    }
}
