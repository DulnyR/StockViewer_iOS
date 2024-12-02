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
            ExploreView()
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

struct ExploreView : View {
    var body: some View {
        VStack {
            TitleView()
            RecommendedListView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CryptoCurrency.self, inMemory: true)
}
