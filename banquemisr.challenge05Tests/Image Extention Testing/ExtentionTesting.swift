//
//  ExtentionTesting.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//


import XCTest
@testable import banquemisr_challenge05

import UIKit

final class ExtentionTesting: XCTestCase {
    var imageView: UIImageView!
       
       override func setUp() {
           super.setUp()
           imageView = UIImageView()
       }
       
       override func tearDown() {
           imageView = nil
           super.tearDown()
       }
       


       func testLoadImageFromInvalidURL() {
           // Given
           let placeholderImage = UIImage(systemName: "xmark") // Placeholder image
           let invalidURLString = "invalid-url"
           let expectation = self.expectation(description: "Placeholder image should be displayed for invalid URL")

           // When
           imageView.loadImage(from: invalidURLString, placeholder: placeholderImage)

           // Then
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder for invalid URL")
               expectation.fulfill()
           }

           waitForExpectations(timeout: 2, handler: nil)
       }

       func testLoadImageWithError() {
           // Given
           let placeholderImage = UIImage(systemName: "xmark") // Placeholder image
           let mockSession = MockURLSession()
           mockSession.error = NSError(domain: "TestError", code: 500, userInfo: nil) // Simulate network error
           let validURLString = "https://example.com/image.png"
           let expectation = self.expectation(description: "Placeholder image should be displayed when network error occurs")

           // When
           imageView.loadImage(from: validURLString, placeholder: placeholderImage)

           // Then
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder on network error")
               expectation.fulfill()
           }

           waitForExpectations(timeout: 2, handler: nil)
       }

       func testLoadImageWithNoData() {
           // Given
           let placeholderImage = UIImage(systemName: "xmark") // Placeholder image
           let mockSession = MockURLSession()
           mockSession.data = nil // Simulate no data returned
           let validURLString = "https://example.com/image.png"
           let expectation = self.expectation(description: "Placeholder image should be displayed when no data is returned")

           // When
           imageView.loadImage(from: validURLString, placeholder: placeholderImage)

           // Then
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.imageView.image, placeholderImage, "Image should be placeholder when no data is returned")
               expectation.fulfill()
           }

           waitForExpectations(timeout: 2, handler: nil)
       }


}
