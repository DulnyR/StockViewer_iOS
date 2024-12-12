//
//  CryptoListRowView.swift
//  StockViewer
//
//  Created by alumno on 29/11/24.
//

import SwiftUI

struct CryptoListRowView: View {
    var crypto: CryptoCurrency
    var euro: Bool
    
    var body: some View {
        NavigationLink {
            CryptoDetailView(crypto: crypto)
        } label: {
            HStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .padding()
                } else {
                    Image(systemName: "hockey.puck.circle.fill")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .padding()
                }
                VStack {
                    HStack {
                        Text(crypto.name)
                            .font(.headline)
                        Spacer()
                    }
                    HStack {
                        Text(crypto.symbol)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                Spacer()
                if(euro) {
                    Text("€\(crypto.eurPrice ?? 0.00, specifier: "%.2f")")
                        .foregroundColor(.gray)
                } else {
                    Text("$\(crypto.usdPrice ?? 0.00, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                if let imageURL = crypto.image {
                    fetchImage(from: imageURL) { fetchedImage in
                        self.image = fetchedImage
                    }
                }
            }
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image.")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
}
