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
    // changed to var
    var session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func setSession(_ session: NetworkSession) {
            self.session = session
        }

    func makeRequest() async throws -> [Product] {

        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            throw NetworkError.invalidURL
        }

            do {
                let (data, response) = try await session.getData(from: url)

                guard let httpResponse = response as? HTTPURLResponse else {

                    throw NetworkError.invalidResponse
                }

                switch httpResponse.statusCode {
                case 200...299:
                    // Successful response, proceed with decoding
                    let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                    return decodedProducts

                case 400...499:
                    // Client error response
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    throw NetworkError.clientError(errorMessage)
                case 500...599:
                    // Server error response
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    throw NetworkError.serverError(errorMessage)

                default:
                    throw NetworkError.invalidResponse
                }
            } catch let decodingError as DecodingError {
                throw NetworkError.jsonDecodingError(decodingError)
            } catch {
                print("The request failed.")
                throw error

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
