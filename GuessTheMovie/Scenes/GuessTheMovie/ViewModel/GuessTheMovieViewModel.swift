//
//  GuessTheMovieViewModel.swift
//  GuessTheMovie
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation

struct LoadingState: Equatable {
    let isLoading: Bool
    let isUserInteractionEnabled: Bool
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
}

protocol GuessTheMovieViewModelProtocol {
    var input: GuessTheMovieViewModel.Input { get }
    var output: GuessTheMovieViewModel.Output { get }
    func getRandomMovie() async throws -> MoviePresentation
    func verifyAnswer(with answer: String) -> Bool
}

final class GuessTheMovieViewModel: GuessTheMovieViewModelProtocol, ViewModelType {
    
    class Input {
        
    }
    
    class Output {
        @Published fileprivate(set) var loadingState: LoadingState = .init(isLoading: false, isUserInteractionEnabled: false)
    }
    
    let input: Input = .init()
    let output: Output = .init()
    
    private var movie: MoviePresentation?
    
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func getRandomMovie() async throws -> MoviePresentation {
        defer {
            output.loadingState = .init(isLoading: false, isUserInteractionEnabled: false)
        }
        
        output.loadingState = .init(isLoading: true, isUserInteractionEnabled: false)
        
        let movies = try await movieRepository.getAll()
        
        guard
            let randomMovie = movies.randomElement(),
            let randomMoviePresentation = MoviePresentation(movie: randomMovie)
        else {
            throw AppError.unknownError
        }
        
        self.movie = randomMoviePresentation
        return randomMoviePresentation
    }
    
    func verifyAnswer(with answer: String) -> Bool {
        guard let movie = movie else { return false }
        return movie.correctAnswer == answer
    }
}
