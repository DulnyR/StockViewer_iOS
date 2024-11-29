//
//  ContentView.swift
//  StockViewer
//
//  Created by alumno on 28/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label ("Home", systemImage: "house")
                }
            HomeView()
                .tabItem {
                    Label ("Explore", systemImage: "magnifyingglass")
                }
         }
        .tint(Color.green)
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            TitleView()
            CryptoListView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CryptoCurrency.self, inMemory: true)
}
