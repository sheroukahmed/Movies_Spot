//
//  TabBarViewModelTests.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import XCTest
@testable import banquemisr_challenge05

import CoreData

import Foundation


struct EventResponse {
    var results: [EventMovie]?
}


// Mock for CoreDataManager
class MockCoreDataManager {
    var storedMovies: [NSManagedObject] = []

    func deleteAllMovies(EnityValue: String) {
        storedMovies.removeAll()
    }

    func storeEvent(Event: EventMovie, EnityValue: String) {
        // Mock storing the event by creating a mock NSManagedObject
        let mockMovie = NSManagedObject()
        mockMovie.setValue(Event.id, forKey: "id")
        mockMovie.setValue(Event.backdrop_path, forKey: "backdrop_path")
        storedMovies.append(mockMovie)
    }

    func getEvent(EnityValue: String, completion: @escaping ([NSManagedObject]?) -> Void) {
        completion(storedMovies)
    }
}

class TabBarViewModelTests: XCTestCase {
    var sut: TabBarViewModel!
    var mockNetwork: MockNetwork!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetwork()
        sut = TabBarViewModel(screenType: "movies", entityType: "Movie")
        sut.network = mockNetwork!
    }


    
    func testLoadDataFailure() {
        let expectation = XCTestExpectation(description: "Show error called")
        sut.showErrorToViewController = { error in
            XCTAssertEqual(error, "Network error: The operation couldn’t be completed. (Test error error 500.)")
            expectation.fulfill()
        }
        
        mockNetwork.fetchSuccess = false
        sut.loadData()

        wait(for: [expectation], timeout: 10)
    }
}
