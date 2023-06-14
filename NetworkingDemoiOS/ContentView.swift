//
//  ContentView.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 5/31/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ProductViewModel()
  @State private var selectedProduct: Product?

  var body: some View {
    VStack {
      Text("Product List")
        .font(.title)
        .bold()
        .padding(.top, 16)

      if viewModel.isLoading {
        ProgressView()
          .padding(.top, 16)
      } else {
        if !viewModel.products.isEmpty {
          ScrollView {
            LazyVStack(spacing: 16) {
              ForEach(viewModel.products) { product in
                Button(action: {
                  selectedProduct = product
                }) {
                  ProductListItemView(product: product)
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)

              }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
          }
        } else {
          Text("No products available. Check your Internet connection.")
            .font(.title)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.top, 16)
        }
      }

      // Sum of items
      if !viewModel.products.isEmpty {
        let totalPrice = viewModel.products.reduce(0) { $0 + $1.price }
        Text("Sum of items: $\(totalPrice, specifier: "%.2f")")
          .font(.title2)
          .fontWeight(.bold)
          .padding(.top, 8)
      }
    }
    .navigationBarTitle("")
    .navigationBarHidden(true)
    .onAppear {
      viewModel.loadProducts()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
