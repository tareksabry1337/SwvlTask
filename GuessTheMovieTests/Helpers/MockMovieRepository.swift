//
//  MockMovieRepository.swift
//  GuessTheMovieTests
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation
@testable import GuessTheMovie

class MockMovieRepository: MovieRepositoryProtocol {
    var stubData: [Movie]?
    
    func getAll() async throws -> [Movie] {
        if let stubData = stubData {
            return stubData
        }
        
        throw AppError.unknownError
    }
    
    
}
