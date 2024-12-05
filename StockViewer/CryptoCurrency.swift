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
    @Attribute var APIid: String
    @Attribute var content: String?
    @Attribute var symbol: String
    
    init(name: String, APIid: String, symbol: String) {
        self.id = UUID()
        self.name = name
        self.APIid = APIid
        self.symbol = symbol
    }
    
    func setDescription(content : String) {
        self.content = content
    }
}
