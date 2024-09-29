//
//  MovieDetailesViewControllerTests.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import XCTest
@testable import banquemisr_challenge05
import Network

class MockMovieDetailesViewModel: movieDetailesViewModel {
    var shouldReturnError: Bool = false
    var moviesResul: Movies?{
        didSet{
            var bindResultToViewController: (() -> ()) {
                get {
                    return super.bindResultToViewController
                }
                set {
                    super.bindResultToViewController = newValue
                }
            }
            
        }
    }

    override var bindResultToViewController: (() -> ()) {
        get {
            return super.bindResultToViewController
        }
        set {
            super.bindResultToViewController = newValue
        }
    }

    override func loadData() {
        if shouldReturnError {
            showErrorToViewController?("Failed to load data")
        } else {
            // Simulate a successful data load
            bindResultToViewController()
        }
    }
}

import XCTest
@testable import banquemisr_challenge05
import Network

class MovieDetailesViewControllerTests: XCTestCase {
    var sut: MovieDetailesViewController!
    var mockViewModel: MockMovieDetailesViewModel!

    override func setUp() {
        super.setUp()
        
        // Load the storyboard and instantiate MovieDetailesViewController
        let storyboard = UIStoryboard(name: "DetailesStoryboard", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "detailesVC") as? MovieDetailesViewController // Assign to 'sut'
        
        // Initialize the mock view model
        mockViewModel = MockMovieDetailesViewModel(movieId: 1)
        sut.movieDetailesVM = mockViewModel
        
        // Load the view to trigger viewDidLoad
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }

    
    func testBackButtonDismissesViewController() {
        // When back button is tapped
        sut.backBtn(UIButton())
        
        // Then: Assert that the view controller is dismissed
        XCTAssertNil(sut.presentingViewController)
    }
}
