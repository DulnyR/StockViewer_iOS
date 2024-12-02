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
                        RecommendedRowView(crypto: currency)
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
                        print("currency changed")
                    }, label: {
                        Text("**USD/EUR**")
                    })
                }
            }
        }
        .tint(Color.green)
        .onAppear {
            fetchRecommended()
        }
    }
    
    func fetchRecommended() {
        let data = Recommended()
        recommended = data.getRecommended()
    }
}
