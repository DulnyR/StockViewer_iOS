//
//  CryptoDetailView.swift
//  StockViewer
//
//  Created by Inna Castro on 10/12/24.
//

import SwiftUI
import Charts

struct CryptoDetailView: View {
    @State private var prices: [Price] = []
    @State private var isLoadingPrices = true
    @State private var percentageChange: Double = 0
    @State private var selectedDays = 1
    @State private var euro: Bool = false
    @State private var isExpanded = false
    @State private var isOptionsSheetPresented = false
    @State private var isAlertSheetPresented = false
    @State private var isViewable: [String: Bool] = [
        "rank" : true,
        "24hHigh" : true,
        "24hLow" : true,
        "marketCap" : true,
        "volume" : true,
        "supply" : true,
        "description" : true
    ]

    var crypto: CryptoCurrency

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text(crypto.name)
                        .font(.largeTitle)
                    Text(crypto.symbol)
                        .font(.title)
                        .foregroundStyle(.gray)
                }
                
                if isLoadingPrices || (crypto.currentPrice?.isEmpty ?? true) {
                    ProgressView("Loading data...")
                } else if prices.isEmpty {
                    Text("No data available.")
                        .foregroundColor(.gray)
                } else {
                    PriceView(euro: euro, crypto: crypto, percentageChange: percentageChange)
                    
                    Chart {
                        ForEach(prices, id: \.timestamp) { price in
                            LineMark(
                                x: .value("Time", dateFromTimestamp(timestamp: price.timestamp)),
                                y: .value("Price", price.value)
                            )
                            .foregroundStyle(.green)
                        }
                    }
                    .chartXScale(domain: xScaleDomain())
                    .chartYScale(domain: yScaleDomain())
                    .frame(height: 200)
                    .padding()
                    
                    Picker("Select Range", selection: $selectedDays) {
                        Text("90 Days").tag(90)
                        Text("30 Days").tag(30)
                        Text("7 Days").tag(7)
                        Text("1 Day").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    WatchButton(crypto: crypto)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12) 
                        .frame(maxWidth: .infinity)
                    
                    AlertFormView(crypto: crypto)
                    
                    CoinStatsView(isViewable: isViewable, crypto: crypto, euro: euro)
                    
                    if isViewable["description"] ?? true {
                        if let coinDescription = crypto.coinDescription {
                            VStack(alignment: .leading, spacing: 8) {

                                Text(coinDescription)
                                    .lineLimit(isExpanded ? nil : 3)
                                    .font(.body)

                                Button(action: {
                                    isExpanded.toggle()
                                }) {
                                    Text(isExpanded ? "View Less" : "View More")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .padding(.top, 4)
                            }
                            .padding()
                        }

                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    crypto.updateDetails()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            ToolbarItem {
                Button(action: {
                    isOptionsSheetPresented.toggle()
                }) {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $isOptionsSheetPresented) {
            OptionsView(euro: euro, isViewable: isViewable) {
                isViewable = CryptoModel.getViewables()
                euro = CryptoModel.isEuro()
                isOptionsSheetPresented = false
            }
        }
        .onChange(of: selectedDays, initial: true) { oldValue, newValue in
            fetchData(days: newValue, currency: (euro ? "eur" : "usd"))
        }
        .onChange(of: euro) { oldValue, newValue in
            fetchData(days: selectedDays, currency: (newValue ? "eur" : "usd"))
        }
        .onAppear {
            euro = CryptoModel.isEuro()
            crypto.updateDetails()
            isViewable = CryptoModel.getViewables()
        }
    }

    private func fetchData(days: Int, currency: String) {
        APIService.getHistoricalPrices(coinId: crypto.APIid, currency: currency, days: days) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.prices = data
                    self.percentageChange = calculatePercentageChange()
                    self.isLoadingPrices = false
                case .failure(let error):
                    print("Error fetching data:", error)
                    self.isLoadingPrices = false
                }
            }
        }
    }
    
    private func xScaleDomain() -> ClosedRange<Date> {
        let timestamps = prices.map { Date(timeIntervalSince1970: TimeInterval($0.timestamp / 1000)) }
        guard let minTime = timestamps.min(), let maxTime = timestamps.max() else {
            return Date()...Date()
        }
        return minTime...maxTime
    }

    private func yScaleDomain() -> ClosedRange<Double> {
        guard let minValue = prices.map({ $0.value }).min(),
              let maxValue = prices.map({ $0.value }).max() else {
            return 0...1
        }
        return minValue...maxValue
    }
    
    private func calculatePercentageChange() -> Double {
       return ((prices.last!.value - prices.first!.value) / prices.first!.value) * 100
    }
    
    private func dateFromTimestamp(timestamp: Int) -> Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }
}

private struct PriceView: View {
    var euro: Bool
    var crypto: CryptoCurrency
    var percentageChange: Double
    
    var body: some View {
        HStack {
            if (euro) {
                Text(CryptoModel.formatPrice(value: (crypto.currentPrice?["eur"])!, euro: euro))
                    .font(.title)
            } else {
                Text(CryptoModel.formatPrice(value: (crypto.currentPrice?["usd"])!, euro: euro))
                    .font(.title)
            }
            Spacer()
            if percentageChange > 0 {
                Image(systemName: "triangle.fill")
                    .foregroundStyle(.green)
                Text("+" + String(format: "%.2f", percentageChange) + "%")
                    .foregroundStyle(.green)
            } else if percentageChange == 0 {
                Text(String(format: "%.2f", percentageChange) + "%")
                    .foregroundStyle(.gray)
            } else {
                Image(systemName: "triangle.fill")
                    .rotationEffect(.degrees(180))
                    .foregroundStyle(.red)
                Text(String(format: "%.2f", percentageChange) + "%")
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
}
