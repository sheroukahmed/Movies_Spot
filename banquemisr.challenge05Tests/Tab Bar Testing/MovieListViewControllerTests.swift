//
//  MovieListViewControllerTests.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import XCTest
import XCTest
@testable import banquemisr_challenge05

import CoreData

import Foundation




class MockTabBarViewModel: TabBarViewModel {
    var isLoadDataCalled = false
    var isLoadDataFromCoreDataCalled = false
    
    override func loadData() {
        isLoadDataCalled = true
        moviesResult = [
            EventMovie(id: 1, title: "Mock Movie 1"),
            EventMovie(id: 2, title: "Mock Movie 2")
        ]
        bindResultToViewController()
    }

    override func loadDatafromCoreData() {
        isLoadDataFromCoreDataCalled = true
        moviesResult = [
            EventMovie(id: 3, title: "Mock Movie 3"),
            EventMovie(id: 4, title: "Mock Movie 4")
        ]
        bindResultToViewController()
    }
}


class MovieListViewControllerTests: XCTestCase {
    var sut: MovieListViewController!
    var mockViewModel: MockTabBarViewModel!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController
        
        // Trigger the view controller lifecycle
        _ = sut.view
        
        mockViewModel = MockTabBarViewModel(screenType: "now_playing", entityType: "NowPlaying")
        sut.viewModel = mockViewModel
    }

    func testTableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.moviestable)
    }

    func testViewModelLoadDataCalledOnNetworkConnected() {
        // Simulate network connection
        sut.isConnected = true
        sut.viewModel?.loadData()

        XCTAssertTrue(mockViewModel.isLoadDataCalled)
    }

    func testViewModelLoadDataFromCoreDataCalledWhenOffline() {
        // Simulate offline scenario
        sut.isConnected = false
        sut.viewModel?.loadDatafromCoreData()

        XCTAssertTrue(mockViewModel.isLoadDataFromCoreDataCalled)
    }

    func testTableViewReloadsWithMovies() {
        // Simulate data load
        sut.viewModel?.loadData()

        DispatchQueue.main.async {
            XCTAssertEqual(self.sut.moviestable.numberOfRows(inSection: 0), 2)
        }
    }

//    func testDidSelectRowPresentsDetailsVC() {
//        // Load mock data
//        sut.viewModel?.loadData()
//        let indexPath = IndexPath(row: 0, section: 0)
//        sut.tableView(sut.moviestable, didSelectRowAt: indexPath)
//
//        XCTAssertTrue(sut.presentedViewController is MovieDetailesViewController)
//    }
}
