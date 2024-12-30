//
//  AlertsView.swift
//  StockViewer
//
//  Created by Radek Dulny on 20/12/24.
//

import SwiftUI

struct AlertsView: View {
    @ObservedObject var viewModel: CryptoViewModel
    @State private var euro: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                AlertFormView(viewModel: viewModel)
                CurrentAlertsView(viewModel: viewModel)
            }
            .navigationTitle(Text("Alerts"))
            .toolbar {
                ToolbarItem {
                    EuroToggle(viewModel: viewModel, euro: $euro)
                }
            }
            .onChange(of: euro, initial: true) { oldValue, newValue in
                viewModel.setEuro(euro: newValue)
            }
            .onAppear {
                euro = viewModel.isEuro()
            }
        }
    }
}
