//
//  CoinStatsView.swift
//  StockViewer
//
//  Created by Radek Dulny on 20/12/24.
//

import SwiftUI

struct CoinStatsView: View {
    var isViewable: [String: Bool]
    var crypto: CryptoCurrency
    var euro: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isViewable["rank"] ?? true {
                HStack {
                    Text("Market Cap Rank: ")
                        .font(.headline)
                    Spacer()
                    if let rank = crypto.marketCapRank {
                        Text("#" + String(rank))
                            .font(.headline)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if isViewable["24hHigh"] ?? true{
                HStack {
                    Text("24H High (\(euro ? "€" : "$")): ")
                        .font(.headline)
                    Spacer()
                    if let volume = crypto.high24h, let value = volume[euro ? "eur" : "usd"] {
                        Text(PriceFormatter.formatPrice(value: value, euro: euro))
                            .font(.headline)
                            .foregroundStyle(.green)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if isViewable["24hLow"] ?? true {
                HStack {
                    Text("24H Low (\(euro ? "€" : "$")): ")
                        .font(.headline)
                    Spacer()
                    if let volume = crypto.low24h, let value = volume[euro ? "eur" : "usd"] {
                        Text(PriceFormatter.formatPrice(value: value, euro: euro))
                            .font(.headline)
                            .foregroundStyle(.red)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if isViewable["marketCap"] ?? true {
                HStack {
                    Text("Market Cap (\(euro ? "€" : "$")): ")
                        .font(.headline)
                    Spacer()
                    if let cap = crypto.marketCap, let value = cap[euro ? "eur" : "usd"] {
                        Text(PriceFormatter.formatPrice(value: value, euro: euro))
                            .font(.headline)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if isViewable["totalVolume"] ?? true {
                HStack {
                    Text("Total Volume (\(euro ? "€" : "$")): ")
                        .font(.headline)
                    Spacer()
                    if let volume = crypto.totalVolume, let value = volume[euro ? "eur" : "usd"] {
                        Text(PriceFormatter.formatPrice(value: value, euro: euro))
                            .font(.headline)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if isViewable["totalSupply"] ?? true {
                HStack {
                    Text("Total Supply: ")
                        .font(.headline)
                    Spacer()
                    if let supply = crypto.totalSupply {
                        Text(String(supply))
                            .font(.headline)
                    } else {
                        Text("N/A")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}
