//
//  OptionsView.swift
//  StockViewer
//
//  Created by Radek Dulny on 15/12/24.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var viewModel: CryptoViewModel
    @State var euro: Bool
    @State var isViewable: [String: Bool]
    var onDone: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Currency")) {
                    Picker(selection: $euro, label: Text("Currency")) {
                        Text("EUR €").tag(true)
                        Text("USD $").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Data")) {
                    ForEach(viewableKeys, id: \.self) { key in
                        Toggle(isOn: binding(for: key)) {
                            Text(formatKey(key))
                        }
                    }
                }
                Section(header: Text("Other")) {
                    Toggle(isOn: binding(for: "description")) {
                        Text("Description")
                    }
                }
            }
            .navigationTitle("Settings")
            .onChange(of: euro, initial: false) { oldValue, newValue in
                viewModel.setEuro(euro: newValue)
            }
            .onChange(of: isViewable, initial: false) { oldValue, newValue in
                viewModel.setViewables(viewables: isViewable)
            }
            .onAppear {
                euro = viewModel.isEuro()
                isViewable = viewModel.getViewables()
            }
            .toolbar {
                if let onDone = onDone {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            onDone()
                        }
                    }
                }
            }
        }
    }
    
    // binds the viewed option
    private func binding(for key: String) -> Binding<Bool> {
        Binding<Bool>(
            get: { isViewable[key] ?? true },
            set: { isViewable[key] = $0 }
        )
    }
    
    // changes dictionary key to text
    private func formatKey(_ key: String) -> String {
        switch key {
        case "rank": return "Market Rank"
        case "24hHigh": return "24 Hour High"
        case "24hLow": return "24 Hour Low"
        case "marketCap": return "Market Cap"
        case "volume": return "Total Volume"
        case "supply": return "Total Supply"
        default: return key.capitalized
        }
    }
    
    private var viewableKeys: [String] {
        ["rank", "24hHigh", "24hLow", "marketCap", "volume", "supply"]
    }
}


