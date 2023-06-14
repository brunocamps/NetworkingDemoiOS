//
//  Product.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 6/13/23.
//

import Foundation

// The Product model complies with the API response we'll be expecting

struct Product: Identifiable, Hashable, Codable {
    var id: Int
    let title: String
    let price: Double
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, image // Specify the coding keys to match the API response
    }
}


struct ProductModel: Codable, Equatable {
    var products: [Product] // Update the type of products to [Product]
    
    enum CodingKeys: String, CodingKey {
        case products // Specify the coding key to match the API response
    }
}
