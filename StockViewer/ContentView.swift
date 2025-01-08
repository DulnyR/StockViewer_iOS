//
//  ContentView.swift
//  StockViewer
//
//  Created by alumno on 28/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label ("Home", systemImage: "house")
                }
            ExploreView(viewModel: viewModel)
                .tabItem {
                    Label ("Explore", systemImage: "magnifyingglass")
                }
            AlertView(viewModel: viewModel)
                .tabItem {
                    Label ("Alerts", systemImage: "alarm.waves.left.and.right")
                }
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label ("Settings", systemImage: "gearshape")
                }
         }
        .tint(Color.green)
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        VStack {
            TitleView()
            CryptoListView(viewModel: viewModel)
        }
    }
}

struct ExploreView : View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        VStack {
            TitleView()
            RecommendedListView(viewModel: viewModel)
        }
    }
}

struct AlertView : View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        VStack {
            TitleView()
            AlertsView(viewModel: viewModel)
        }
    }
}

struct SettingsView : View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        OptionsView(viewModel: viewModel, euro: viewModel.isEuro(), isViewable: viewModel.getViewables())
    }
}
