//
//  JSONDecoderExtension.swift
//  GuessTheMovie
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation

extension JSONDecoder {
    
    static let snakeCaseDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
}
