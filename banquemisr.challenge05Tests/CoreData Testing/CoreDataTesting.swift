//
//  CoreDataTesting.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import XCTest
import CoreData
@testable import banquemisr_challenge05


struct Genre {
    let id: Int
    let name: String
}



class CoreDataTesting: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        // Initialize the core data manager
        coreDataManager = CoreDataManager.shared
        // Create the in-memory persistent container
        let persistentContainer = createInMemoryPersistentContainer()
        // Set the context to be used in tests
        coreDataManager.setContext(persistentContainer.viewContext)
    }
    
    override func tearDown() {
        // Clean up
        coreDataManager = nil
        mockContext = nil
        super.tearDown()
    }
    
    private func createInMemoryPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "banquemisr.challenge05") // Ensure this matches your Core Data model name
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        // Load the persistent stores
        container.loadPersistentStores { (_, error) in
            XCTAssertNil(error, "Failed to load in-memory store: \(error?.localizedDescription ?? "")")
        }
        
        return container
    }
    
 

   
    // Test fetching movies
    func testGetMovie() {
        // Given
        let genre = Genres(name: "Action") // Use Genres instead of Genre
        let movie = Movies(id: 1, genres: [genre], original_language: "en", original_title: "Test Movie", overview: "Test overview", poster_path: "/poster.jpg", release_date: "2024-01-01", runtime: 120, vote_average: 8.0, backdrop_path: "/path.jpg")

        coreDataManager.storeMovie(currentMovie: movie)
        
        // When
        let expectation = self.expectation(description: "Fetch Movies")
        coreDataManager.getMovie { results in
            // Then
            XCTAssertNotNil(results)
            XCTAssertEqual(results?.count, 1, "Should fetch one movie")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    // Test deleting all movies
    func testDeleteAllMovies() {
        // Given
        let genre = Genres(name: "Action") // Use Genres instead of Genre
        let movie = Movies(id: 1, genres: [genre], original_language: "en", original_title: "Test Movie", overview: "Test overview", poster_path: "/poster.jpg", release_date: "2024-01-01", runtime: 120, vote_average: 8.0, backdrop_path: "/path.jpg")

        coreDataManager.storeMovie(currentMovie: movie)
        
        // When
        coreDataManager.deleteAllMovies(EnityValue: "Movie")
        
        // Then
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 0, "Should delete all movies")
        } catch {
            XCTFail("Failed to fetch stored movies: \(error.localizedDescription)")
        }
    }
}

