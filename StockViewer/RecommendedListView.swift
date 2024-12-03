//
//  RecommendedListView.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import SwiftUI

struct RecommendedListView: View {
    @State private var recommended: [CryptoCurrency] = []
    @State private var searchText = ""
    @State private var euro = true
    @State private var fetched = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Top Coins")
                        .font(.headline)
                    Image(systemName: "star.fill")
                }
                List {
                    ForEach(recommended) { currency in
                        RecommendedRowView(crypto: currency, euro: euro)
                    }
                    ForEach(CryptoModel.getFirstTenMatches(substring: "bit"), id: \.self) { coin in
                        Text(coin)
                    }
                }
                .searchable(text: $searchText)
                .listRowSpacing(12.0)
                .contentMargins(.top, 6)
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        euro.toggle()
                    }, label: {
                        euro ? Text("**EUR €**") : Text("**USD $**")
                    })
                }
            }
        }
        .onAppear {
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
