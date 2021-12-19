//
//  MoviePresentation.swift
//  GuessTheMovie
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation

struct MoviePresentation {
    
    let obfuscatedName: String
    let image: String
    let answers: [String]
    let correctAnswer: String
    
    init?(movie: Movie) {
        let movieNameComponents = movie.name.components(separatedBy: " ")
        
        guard
            let correctAnswer = movieNameComponents.randomElement(),
            let correctAnswerIndex = movieNameComponents.firstIndex(of: correctAnswer)
        else {
            return nil
        }
        
        let stars = [String](repeating: "*", count: correctAnswer.count).joined()
        
        var obfuscatedNameComponents = movieNameComponents
        obfuscatedNameComponents[correctAnswerIndex] = stars
        
        var answers = movie.wrongAnswers
        answers.append(correctAnswer)
        answers.shuffle()
        
        self.obfuscatedName = obfuscatedNameComponents.joined(separator: " ")
        self.image = movie.image
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
    
}
