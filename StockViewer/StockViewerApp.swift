//
//  StockViewerApp.swift
//  StockViewer
//
//  Created by alumno on 28/11/24.
//

import SwiftUI
import SwiftData

@main
struct StockViewerApp: App {
    @StateObject var viewModel: CryptoViewModel = CryptoViewModel()
    
    init() {
        NotificationManager.shared.registerBackgroundTasks()
        NotificationManager.shared.requestAuthorization()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CryptoCurrency.self,
            CryptoAlert.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
