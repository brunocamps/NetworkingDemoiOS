//
//  ProductViewModel.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 6/13/23.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    private let networkManager = NetworkManager()

    func loadProducts() {
        isLoading = true
        networkManager.makeRequest { result in
            DispatchQueue.main.async { [self] in
                self.isLoading = false
                switch result {
                case .success(let products):
                    self.products = products
                    saveProductsToJSON() // save products to JSON after loading
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

    func saveProductsToJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(products)
            let documentsURL = FileManager.documentsDirectoryURL
            let fileURL = documentsURL.appendingPathComponent("products.json")

            try jsonData.write(to: fileURL)

            print("Products saved to: \(fileURL.absoluteString)")
        } catch {
            print("Failed to save products: \(error)")
        }
    }
}
