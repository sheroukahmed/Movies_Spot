//
//  NetworkTesting.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import XCTest
@testable import banquemisr_challenge05


final class NetworkTesting: XCTestCase {

    var mockSession: MockURLSession!
        var network: Network!

        override func setUp() {
            super.setUp()
            mockSession = MockURLSession()
            network = Network(session: mockSession)
        }

        override func tearDown() {
            mockSession = nil
            network = nil
            super.tearDown()
        }


        func testFetchSuccess() {
           
            let mockResponseData = """
            {
                "id": 123,
                "title": "Test Movie"
            }
            """.data(using: .utf8)
            
            mockSession.data = mockResponseData
            
            let expectation = self.expectation(description: "Completion handler invoked")
            var responseObject: TestResponseModel? = nil
            var responseError: Error? = nil
            
          
            network.fetch(url: "https://example.com", type: TestResponseModel.self) { response, error in
                responseObject = response
                responseError = error
                expectation.fulfill()
            }

          
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertNotNil(responseObject)
            XCTAssertNil(responseError)
            XCTAssertEqual(responseObject?.id, 123)
            XCTAssertEqual(responseObject?.title, "Test Movie")
        }

      
        func testFetchWithError() {
          
            mockSession.error = NSError(domain: "NetworkError", code: -1, userInfo: nil)
            
            let expectation = self.expectation(description: "Completion handler invoked")
            var responseObject: TestResponseModel? = nil
            var responseError: Error? = nil
            
          
            network.fetch(url: "https://example.com", type: TestResponseModel.self) { response, error in
                responseObject = response
                responseError = error
                expectation.fulfill()
            }

            
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertNil(responseObject)
            XCTAssertNotNil(responseError)
        }
        
       
        func testFetchWithNoData() {
           
            mockSession.data = nil
            
            let expectation = self.expectation(description: "Completion handler invoked")
            var responseObject: TestResponseModel? = nil
            var responseError: Error? = nil
           
            network.fetch(url: "https://example.com", type: TestResponseModel.self) { response, error in
                responseObject = response
                responseError = error
                expectation.fulfill()
            }

           
            waitForExpectations(timeout: 2, handler: nil)
            XCTAssertNil(responseObject)
            XCTAssertNotNil(responseError)
            XCTAssertEqual((responseError as NSError?)?.domain, "No Data")
        }
    }


  
    struct TestResponseModel: Codable {
        let id: Int
        let title: String
    }


