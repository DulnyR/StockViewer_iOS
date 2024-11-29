//
//  TitleView.swift
//  StockViewer
//
//  Created by alumno on 28/11/24.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack {
            Spacer()
            
            Text("Stock")
                .font(.title)
    
            + Text("Viewer")
                .font(.title)
                .foregroundStyle(.green)
            Image(systemName: "chart.line.uptrend.xyaxis")
            
            Spacer()
        }
        .padding()
        Divider()
        Spacer()
    }
}

#Preview {
    TitleView()
}
