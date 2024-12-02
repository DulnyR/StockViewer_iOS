//
//  ExploreView.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            Text("Searching")
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    SearchView()
}
