//
//  MockNetwork.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import Foundation
import XCTest
@testable import banquemisr_challenge05

class MockURLSession: URLSession {
    var data: Data?
    var error: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        task.completionHandler = {
            completionHandler(self.data, nil, self.error)
        }
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        completionHandler?()
    }
}

class MockNetwork: networkProtocol {
    var fetchSuccess: Bool = true
    var mockMovie: Movies?
    func fetch<T>(url: String, type: T.Type, completionHandler: @escaping (T?, Error?) -> Void) where T : Decodable, T : Encodable {
        if fetchSuccess {
            // Simulate success response with mock data
            let mockResult = EventResponse(results: [
                EventMovie(id: 1, title: "Test Movie 1"),
                EventMovie(id: 2, title: "Test Movie 2")
            ])
            print("Mock network returning success with 2 movies")  // Debugging statement
            completionHandler(mockResult as? T, nil)
        } else {
            print("Mock network returning error")  // Debugging statement
            completionHandler(nil, NSError(domain: "Test error", code: 500, userInfo: nil))
        }
    }
}


