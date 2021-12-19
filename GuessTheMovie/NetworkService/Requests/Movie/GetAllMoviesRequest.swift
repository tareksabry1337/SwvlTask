//
//  GetAllMoviesRequest.swift
//  GuessTheMovie
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation

struct GetAllMoviesRequest: RequestProtocol {
    
    let url: URL
    
    init() {
        url = Configuration.baseURL.appendingPathComponent(MovieEndpoints.getAll)
    }
}
