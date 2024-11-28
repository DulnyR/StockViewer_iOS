//
//  Item.swift
//  StockViewer
//
//  Created by alumno on 28/11/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
