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
            
            Text("StockViewer")
                .font(.title)
            Image(systemName: "chart.line.uptrend.xyaxis")
            
            Spacer()
        }
        Divider()
        Spacer()
    }
}

#Preview {
    TitleView()
}
