//
//  EuroToggle.swift
//  StockViewer
//
//  Created by alumno on 11/12/24.
//

import SwiftUI

struct EuroToggle: View {
    @Binding var euro: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                euro.toggle()
                CryptoModel.updateEuro(euro: euro)
            }) {
                HStack {
                    Text(euro ? "EUR €" : "USD $")
                        .padding()
                }
            }
        }
        .onAppear {
            euro = CryptoModel.isEuro()
        }
    }
}
