//
//  StubData.swift
//  GuessTheMovieTests
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation
@testable import GuessTheMovie

extension Movie {
    
    static let stubData: [Movie] = {
        let url = Bundle.main.url(forResource: "stub_data", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder.snakeCaseDecoder.decode([Movie].self, from: data)
    }()
    
}
