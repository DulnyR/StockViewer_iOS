//
//  RecommendedListView.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import SwiftUI
import SwiftData

struct RecommendedListView: View {
    @State private var recommended: [CryptoCurrency] = []
    @State private var searchText = ""
    @State private var fetched = false
    @State private var euro = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if !searchText.isEmpty {
                    let matches = CryptoModel.getFirstTenMatches(substring: searchText)
                    
                    if matches.isEmpty {
                        Text("No matches found for '\(searchText)'")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        List {
                            ForEach(matches, id: \.self) { coin in
                                CryptoListRowView(crypto: coin, euro: euro, showPrice: false)
                            }
                        }
                    }
                } else {
                    HStack {
                        Text("StockViewer® Top Coins")
                            .font(.headline)
                        Image(systemName: "star.fill")
                    }
                    List {
                        ForEach(recommended) { currency in
                            RecommendedRowView(crypto: currency, euro: euro)
                        }
                    }
                    .listRowSpacing(12.0)
                    .contentMargins(.top, 6)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem {
                    EuroToggle(euro: $euro)
                }
            }
        }
        .onAppear {
            euro = CryptoModel.isEuro()
            if (!fetched) {
                fetchRecommended()
            }
            fetched = true
        }
        .tint(Color.green)
    }
    
    func fetchRecommended() {
        let data = Recommended()
        recommended = data.getRecommended()
    }
}
