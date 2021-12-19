//
//  GuessTheMovieViewController.swift
//  CompleteTheMovieTitle
//
//  Created by Osama Gamal on 25/05/2021.
//

import UIKit
import Combine
import CombineCocoa

final class GuessTheMovieViewController: UIViewController {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private var answerButtons: [UIButton]!
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: GuessTheMovieViewModelProtocol
    
    init?(coder: NSCoder, viewModel: GuessTheMovieViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservables()
        displayRandomMovie()
    }
    
    private func addObservables() {
        let publishers = answerButtons
            .compactMap { button in
                button
                    .tapPublisher
                    .compactMap { button.titleLabel?.text }
            }
        
        Publishers.MergeMany(publishers)
            .sink { [weak self] title in
                guard let self = self else { return }
                self.verifyAnswer(title: title)
            }
            .store(in: &cancellables)
        
        viewModel
            .output
            .$loadingState
            .sink { loadingState in
                if loadingState.isLoading {
                    //Check isUserInteractionEnabled
                } else {
                    //Hide loading
                }
            }
            .store(in: &cancellables)
    }
    
    private func displayRandomMovie() {
        Task {
            do {
                let randomMovie = try await viewModel.getRandomMovie()
                render(movie: randomMovie)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func render(movie: MoviePresentation) {
        movieImageView.image = UIImage(named: movie.image)
        movieTitleLabel.text = movie.obfuscatedName
        
        for (answer, button) in zip(movie.answers, answerButtons) {
            button.setTitle(answer, for: .normal)
        }
    }
    
    private func verifyAnswer(title: String) {
        if viewModel.verifyAnswer(with: title) {
            showAlert(message: "Answer is correct")
        } else {
            showAlert(message: "Answer is wrong")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Another Random Quiz", style: .default) { _ in
            self.displayRandomMovie()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension GuessTheMovieViewController {
    
    static func create() -> GuessTheMovieViewController {
        let networkClient = NetworkClient()
        let movieRepository = MovieRepository(networkClient: networkClient)
        let viewModel = GuessTheMovieViewModel(movieRepository: movieRepository)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "\(Self.self)") { coder in
            return GuessTheMovieViewController(coder: coder, viewModel: viewModel)
        }
    }
    
}
