//
//  CryptoDetailView.swift
//  StockViewer
//
//  Created by Inna Castro on 10/12/24.
//

import SwiftUI
import Charts

struct CryptoDetailView: View {
    @State var prices: [Price] = []
    @State var isLoading = true
    @State var percentageChange: Double = 0

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
                    Spacer()
                    if percentageChange > 0 {
                        Text("+" + String(format: "%.2f", percentageChange) + "%")
                            .foregroundStyle(.green)
                    } else if percentageChange == 0 {
                        Text(String(format: "%.2f", percentageChange) + "%")
                            .foregroundStyle(.gray)
                    } else {
                        Text(String(format: "%.2f", percentageChange) + "%")
                            .foregroundStyle(.red)
                    }
                }
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
                    Spacer()
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }

    private func fetchData() {
        APIService.getHistoricalPrices(coinId: crypto.APIid, currency: "usd", days: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.prices = data
                    self.percentageChange = calculatePercentageChange()
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
