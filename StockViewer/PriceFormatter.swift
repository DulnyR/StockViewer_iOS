//
//  PriceFormatter.swift
//  StockViewer
//
//  Created by Radek Dulny on 26/12/24.
//

import Foundation

public class PriceFormatter {
    // function used to format price
    public static func formatPrice(value: Double, euro: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = euro ? "EUR" : "USD"
        formatter.currencySymbol = euro ? "€" : "$"
        formatter.locale = Locale(identifier: "en_US")
        var digits = 6
        if value > 1000000 {
            digits = 0
        } else if value > 10 {
            digits = 2
        }
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
