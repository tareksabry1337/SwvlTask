//
//  GuessTheMovieViewModelTests.swift
//  GuessTheMovieTests
//
//  Created by Tarek Sabry on 19/12/2021.
//

import Foundation
import CombineTestExtensions

import XCTest
@testable import GuessTheMovie

class GuessTheMovieViewModelTests: XCTestCase {
    
    private var mockMovieRepository: MockMovieRepository!
    private var viewModel: GuessTheMovieViewModel!
    
    override func setUp() {
        super.setUp()
        mockMovieRepository = .init()
        viewModel = .init(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadingIndicatorShowsAndHides() async {
        //Record initial value of published + two new values
        let recorder = viewModel.output.$loadingState.record(numberOfRecords: 3)
        
        mockMovieRepository.stubData = Movie.stubData
        
        do {
            _ = try await viewModel.getRandomMovie()
        } catch {
            XCTFail("Get random movie shouldn't fail")
        }
        
        let records = recorder.waitAndCollectRecords()
        
        XCTAssertEqual(records, [
            .value(.init(isLoading: false, isUserInteractionEnabled: false)),
            .value(.init(isLoading: true, isUserInteractionEnabled: false)),
            .value(.init(isLoading: false, isUserInteractionEnabled: false))
        ])
    }
    
    func testUnknownErrorThrowsIfDataIsNil() async  {
        do {
            _ = try await viewModel.getRandomMovie()
        } catch {
            XCTAssertEqual(error.localizedDescription, AppError.unknownError.localizedDescription)
        }
    }
    
    func testVerifyAnswer() async {
        mockMovieRepository.stubData = Movie.stubData
        
        do {
            let randomMovie = try await viewModel.getRandomMovie()
            let correctAnswer = randomMovie.correctAnswer
            XCTAssertTrue(viewModel.verifyAnswer(with: correctAnswer))
        } catch {
            XCTFail("Get random movie shouldn't fail")
        }
    }
}
