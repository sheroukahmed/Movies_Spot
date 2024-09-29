//
//  MockCoreData.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import Foundation

import XCTest
import CoreData
@testable import banquemisr_challenge05

class CoreDataManagerTests: XCTestCase {

        var storedMovies: [NSManagedObject] = []
        
        func deleteAllMovies(EnityValue: String) {
            storedMovies.removeAll()
        }
        
        func storeEvent(Event: EventMovie, EnityValue: String) {
            let mockMovie = NSManagedObject() // Use your NSManagedObject subclass if applicable
            mockMovie.setValue(Event.id, forKey: "id")
            // Set other values...
            storedMovies.append(mockMovie)
        }
        
        func getEvent(EnityValue: String, completion: @escaping ([NSManagedObject]?) -> Void) {
            completion(storedMovies)
        }
    

}
