//
//  NetworkingManager.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 6/13/23.
//

import Foundation
// Get from fakestoreapi.com/products


protocol NetworkSession {
    func getData(from url: URL) async throws -> (Data, URLResponse)
}

enum MockSessionError: Error {
    case badPath
    case badURL
    case badData
}

extension URLSession: NetworkSession {
    func getData(from url: URL) async throws -> (Data, URLResponse) {
        let (data, response) = try await self.data(from: url)
        return (data, response)
    }
}

// Add NetworkManager class
class NetworkManager {
    let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func makeRequest(completion: @escaping (Result<[Product], Error>) -> Void) {
        // Change JSON to the API link
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        Task {
            do {
                let (data, response) = try await session.getData(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    // Successful response, proceed with decoding
                    let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                    let products = decodedProducts.map { product in
                        Product(id: product.id, title: product.title, price: product.price, image: product.image)
                    }
                    completion(.success(products))
                    
                case 400...499:
                    // Client error response
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(NetworkError.clientError(errorMessage)))
                    print("Error 400...499: Client Error response")
                case 500...599:
                    // Server error response
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(NetworkError.serverError(errorMessage)))
                    // print(completion)
                    print("Error 500...599: Server Error response")
                    
                default:
                    completion(.failure(NetworkError.invalidResponse))
                    // print(completion)
                    print("Network/Default Error response")
                }
            } catch let decodingError as DecodingError {
                completion(.failure(NetworkError.jsonDecodingError(decodingError)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case clientError(ErrorMessage)
    case serverError(ErrorMessage)
    case jsonDecodingError(DecodingError)
}

struct ErrorMessage: Decodable {
    let error: String
}
