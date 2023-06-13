//
//  Product.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 6/13/23.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
    var id: Int // Change the id type to Int
    let title: String // Change the name property to title
    let price: Double
    let image: String // Change imageName property to image
    
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