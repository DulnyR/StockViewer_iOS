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
                saveEuroToUserDefaults(euro: euro)
            }) {
                HStack {
                    Text(euro ? "EUR €" : "USD $")
                        .padding()
                }
            }
        }
        .onAppear {
            euro = euroFromUserDefaults()
        }
    }
    private func saveEuroToUserDefaults(euro: Bool) {
        UserDefaults.standard.set(euro, forKey: "euro")
    }

    private func euroFromUserDefaults() -> Bool {
        return UserDefaults.standard.bool(forKey: "euro")
    }
}
