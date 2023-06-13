//
//  ProductListItemView.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 6/13/23.
//

import SwiftUI

struct ProductListItemView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .resizable()
                    .frame(width: 80, height: 80)
            } placeholder: {
                Color.gray
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                Text("$\(product.price, specifier: "%.2f")")
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}



//struct ProductListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductListItemView()
//    }
//}
