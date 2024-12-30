//
//  EuroToggle.swift
//  StockViewer
//
//  Created by alumno on 11/12/24.
//

import SwiftUI

// used to toggle between euro and dollars
struct EuroToggle: View {
    @StateObject var viewModel: CryptoViewModel
    @Binding var euro: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                euro.toggle()
                viewModel.setEuro(euro: euro)
            }) {
                HStack {
                    Text(euro ? "EUR €" : "USD $")
                        .padding()
                }
            }
        }
        .onAppear {
            euro = viewModel.isEuro()
        }
    }
}
