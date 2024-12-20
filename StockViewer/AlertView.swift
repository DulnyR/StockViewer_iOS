//
//  AlertView.swift
//  StockViewer
//
//  Created by Inna Castro on 16/12/24.
//

import SwiftUI
import SwiftData

struct AlertView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currencies: [CryptoCurrency]
    @Query private var alerts: [CryptoAlert]
    @State private var crypto: CryptoCurrency?
    @State private var priceString: String = ""
    @State private var percentageString: String = ""
    @State private var price: Double?
    @State private var percentage: Double?
    @State private var increase: Bool = true
    var onDone: (() -> Void)?
    
    var body: some View {
        NavigationView {
            List {
                if alerts.isEmpty {
                    Text("No alerts set")
                        .foregroundColor(.gray)
                } else {
                    ForEach(alerts) { alert in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(alert.cryptoName)
                                    .font(.headline)
                                Text("Target: \(alert.targetPrice, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                            Spacer()
                            if let percentage = alert.percentage {
                                let isIncrease = percentage > 0
                                Text((isIncrease ? "+" : "-") + "\(percentage)%")
                                    .foregroundColor(isIncrease ? .green : .red)
                                    .fontWeight(.bold)
                            } else {
                                Text("Price Alert")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .onDelete(perform: deleteAlert)
                }
            }
            .navigationTitle("Current Alerts")

            Form {
                Section(header: Text("Choose Cryptocurrency")) {
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
                    }
                }
                
                Section(header: Text("Set Price Alert")) {
                    TextField("Enter target price", text: $priceString)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Set Percentage Change Alert")) {
                    Picker(selection: $increase, label: Text("% Change")) {
                        Text("+% Increase").tag(true)
                        Text("-% Decrease").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .foregroundColor(increase ? .green : .red)
                    
                    TextField(
                        increase ? "Enter increase percentage: " : "Enter decrease percentage: ",
                        text: $percentageString
                    )
                    .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Set Price Alert")
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
                    .disabled(crypto == nil || (price == nil && percentage == nil))
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDone?()
                    }
                }
            }
            .onChange(of: priceString, initial: false) { oldValue, newValue in
                price = Double(newValue)
            }
            .onChange(of: percentageString, initial: false) { oldValue, newValue in
                percentage = Double(newValue)
            }
            .onAppear {
                NotificationManager.shared.requestAuthorization()
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
    
    private func deleteAlert(at offsets: IndexSet) {
        for index in offsets {
            let alert = alerts[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alert.id.uuidString])
            withAnimation {
                modelContext.delete(alert)
            }
        }
    }
    
}

#Preview {
    AlertView()
}
