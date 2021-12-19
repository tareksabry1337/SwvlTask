//
//  NetworkClient.swift
//  CompleteTheMovieTitle
//
//  Created by Osama Gamal on 25/05/2021.
//

import Foundation

protocol RequestProtocol {
    var url: URL { get }
}

class NetworkClient {
    
    func get(request: RequestProtocol) async throws -> Data  {
        let urlRequest = URLRequest(url: request.url)
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if error != nil {
                    continuation.resume(throwing: NetworkError.networkError)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: NetworkError.noData)
                    return
                }
                
                continuation.resume(returning: data)
            }
            .resume()
        }
    }
    
    func getDecodable<T: Decodable>(request: RequestProtocol, ofType type: T.Type, using decoder: JSONDecoder = .init()) async throws -> T {
        let data = try await get(request: request)
        let result = try decoder.decode(T.self, from: data)
        return result
    }
}

enum NetworkError: Error {
    case noData
    case networkError
}
