//
//  AlertView.swift
//  StockViewer
//
//  Created by Inna Castro on 16/12/24.
//

import SwiftUI
import SwiftData

struct AlertSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var alerts: [CryptoAlert]
    @State var crypto: CryptoCurrency?
    @State private var price: Double?
    @State private var percentage: Double?
    var onDone: (() -> Void)?
    
    var body: some View {
        NavigationView {
            AlertFormView(crypto: $crypto, price: $price, percentage: $percentage)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if price != nil {
                            savePriceAlert()
                        }
                        if percentage != nil{
                            savePercentageAlert()
                        }
                    }
                    .disabled(price == nil && percentage == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDone?()
                    }
                }
            }
        }
    }
    
    private func savePriceAlert() {
        guard let crypto = crypto, let price = price else { return }
        
        NotificationManager.shared.startMonitoringPrice(crypto: crypto, price: price)
        
        let alert = CryptoAlert(cryptoName: crypto.name, targetPrice: ((CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"])!))
        
        withAnimation {
            modelContext.insert(alert)
        }
        
        onDone?()
    }
    
    private func savePercentageAlert() {
        guard let crypto = crypto, let percentage = percentage else { return }
        
        NotificationManager.shared.startMonitoringPercentage(crypto: crypto, price: ((CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"])!), percentage: percentage)
        
        let alert = CryptoAlert(cryptoName: crypto.name, targetPrice: ((CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"])!), percentage: percentage)
        
        withAnimation {
            modelContext.insert(alert)
        }
        
        onDone?()
    }
}

