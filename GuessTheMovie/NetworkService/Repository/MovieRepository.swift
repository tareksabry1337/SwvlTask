//
//  MovieRepository.swift
//  GuessTheMovie
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getAll() async throws -> [Movie]
}

class MovieRepository: MovieRepositoryProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getAll() async throws -> [Movie] {
        let request = GetAllMoviesRequest()
        return try await networkClient.getDecodable(request: request, ofType: [Movie].self, using: .snakeCaseDecoder)
    }
}
