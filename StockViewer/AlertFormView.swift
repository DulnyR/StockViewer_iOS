//
//  AlertFormView.swift
//  StockViewer
//
//  Created by Inna Castro on 20/12/24.
//

import SwiftUI
import SwiftData

struct AlertFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currencies: [CryptoCurrency]
    @Query private var alerts: [CryptoAlert]
    @State var crypto: CryptoCurrency?
    @State var price: Double?
    @State var percentage: Double?
    @State private var priceString: String = ""
    @State private var percentageString: String = ""
    @State private var selection: Int = 0
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Alert me when:")
                    .fontWeight(.bold)
                    .padding(.bottom, 8) // Reduce space below header
                ) {
                    if currencies.isEmpty {
                        Text("Add more coins to your watchlist to set alerts.")
                            .foregroundColor(.gray)
                    } else {
                        Picker("Cryptocurrency", selection: $crypto) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency.name).tag(currency as CryptoCurrency?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Picker(selection: $selection, label: Text("% Change")) {
                            Text("Reaches").tag(0)
                            Text("Increases by").tag(1)
                            Text("Decreases by").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        HStack {
                            switch(selection) {
                                case 0:
                                    TextField("Enter target price: ", text: $priceString)
                                        .keyboardType(.decimalPad)
                                    Text(CryptoModel.isEuro() ? "€" : "$")
                                case 1:
                                    TextField("Enter increase percentage: ", text: $percentageString)
                                        .keyboardType(.decimalPad)
                                    Text("%")
                                case 2:
                                    Text("-")
                                    TextField("Enter decrease percentage: ", text: $percentageString)
                                        .keyboardType(.decimalPad)
                                    Text("%")
                                default:
                                    Text("default reached")
                            }
                        }
                    }
                }
            }
            .frame(height: 200)
            .onChange(of: priceString, initial: false) { oldValue, newValue in
                price = Double(newValue)
            }
            .onChange(of: percentageString, initial: false) { oldValue, newValue in
                percentage = Double(newValue)
            }
            .onAppear {
                NotificationManager.shared.requestAuthorization()
            }
            
            Button("Save Alert") {
                if price != nil {
                    savePriceAlert()
                }
                if percentage != nil{
                    savePercentageAlert()
                }
            }
            .disabled(crypto == nil || (price == nil && percentage == nil))
        }
    }
    
    private func savePriceAlert() {
        guard let crypto = crypto, let price = price else { return }
        
        let currentPrice = ((CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"])!)
        
        let alert = CryptoAlert(cryptoName: crypto.name, targetPrice: price)
        print("Created Alert: \(alert)")
        
        modelContext.insert(alert)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save model context: \(error)")
        }
        
        print("Currencies: \(currencies)")
        print("Alerts: \(alerts)")
        
        let increase =  currentPrice > price
        
        NotificationManager.shared.startMonitoringPrice(crypto: crypto, price: price, increase: increase)
    }
    
    private func savePercentageAlert() {
        guard let crypto = crypto, let percentage = percentage else { return }
        
        let alert = CryptoAlert(cryptoName: crypto.name, targetPrice: ((CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"])!), percentage: percentage)
        
        withAnimation {
            modelContext.insert(alert)
        }
        
        NotificationManager.shared.startMonitoringPercentage(crypto: crypto, price: ((CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"])!), percentage: percentage)
    }
}
