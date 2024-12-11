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
    @State private var isLoading = true
    @State private var percentageChange: Double = 0
    @State private var currentPrice: Double = 0
    @State private var selectedDays = 1
    @State private var euro: Bool = false

    var crypto: CryptoCurrency

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(crypto.name)
                        .font(.largeTitle)
                    Text(crypto.symbol)
                        .font(.title)
                        .foregroundStyle(.gray)
                }
                HStack {
                    if currentPrice >= 0.01 {
                        Text((euro ? "€" : "$") + String(format: "%.2f", currentPrice))
                            .font(.title)
                    } else {
                        Text((euro ? "€" : "$") + String(format: "%.6f", currentPrice))
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
                            .foregroundStyle(.red)
                        Text(String(format: "%.2f", percentageChange) + "%")
                            .foregroundStyle(.red)
                    }
                }
                .padding()
                
                if isLoading {
                    ProgressView("Loading data...")
                } else if prices.isEmpty {
                    Text("No data available.")
                        .foregroundColor(.gray)
                } else {
                    Chart {
                        ForEach(prices, id: \.timestamp) { price in
                            LineMark(
                                x: .value("Time", Date(timeIntervalSince1970: TimeInterval(price.timestamp / 1000))),
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
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem {
                EuroToggle(euro: $euro)
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
        }
    }

    private func fetchData(days: Int, currency: String) {
        APIService.getHistoricalPrices(coinId: crypto.APIid, currency: currency, days: days) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.prices = data
                    self.percentageChange = calculatePercentageChange()
                    if (days == 1) {
                        self.currentPrice = prices.last!.value
                    }
                    self.isLoading = false
                case .failure(let error):
                    print("Error fetching data:", error)
                    self.isLoading = false
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
}
