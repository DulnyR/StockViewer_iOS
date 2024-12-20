//
//  AlertsView.swift
//  StockViewer
//
//  Created by Inna Castro on 20/12/24.
//

import SwiftUI

struct AlertsView: View {
    @State private var euro: Bool = CryptoModel.isEuro()
    
    var body: some View {
        NavigationStack {
            VStack {
                AlertFormView()
                CurrentAlertsView()
            }
            .navigationTitle(Text("Alerts"))
            .toolbar {
                ToolbarItem {
                    EuroToggle(euro: $euro)
                }
            }
            .onChange(of: euro, initial: true) { oldValue, newValue in
                CryptoModel.updateEuro(euro: newValue)
            }
        }
    }
}

#Preview {
    AlertsView()
}
