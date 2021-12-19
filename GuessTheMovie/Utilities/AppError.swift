//
//  AppError.swift
//  GuessTheMovie
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation

enum AppError: Error, LocalizedError {
    case unknownError
    
    var errorDescription: String? {
        return "Something went wrong"
    }
}
