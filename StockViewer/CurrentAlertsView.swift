//
//  CurrentAlertsView.swift
//  StockViewer
//
//  Created by Inna Castro on 20/12/24.
//

import SwiftUI
import SwiftData

struct CurrentAlertsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var alerts: [CryptoAlert]
    
    var body: some View {
        VStack {
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
                                Text("Target: \(CryptoModel.formatPrice(value: alert.targetPrice, euro: CryptoModel.isEuro()))")
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
        }
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
