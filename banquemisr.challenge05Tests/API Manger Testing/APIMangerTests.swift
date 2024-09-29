//
//  APIMangerTests.swift
//  banquemisr.challenge05Tests
//
//  Created by  sherouk ahmed  on 29/09/2024.
//

import XCTest
@testable import banquemisr_challenge05


final class APIMangerTests: XCTestCase {

    func testGetFullURL_Upcoming() {
        let expectedURL = "https://api.themoviedb.org/3/movie/upcoming"
        let result = APIManger.getFullURL(details: "upcoming")
        XCTAssertEqual(result, expectedURL, "The full URL for upcoming movies should be \(expectedURL)")
    }
    
    func testGetFullURL_Popular() {
        let expectedURL = "https://api.themoviedb.org/3/movie/popular"
        let result = APIManger.getFullURL(details: "popular")
        XCTAssertEqual(result, expectedURL, "The full URL for popular movies should be \(expectedURL)")
    }
    
    func testGetFullURL_NowPlaying() {
        let expectedURL = "https://api.themoviedb.org/3/movie/now_playing"
        let result = APIManger.getFullURL(details: "now_playing")
        XCTAssertEqual(result, expectedURL, "The full URL for now playing movies should be \(expectedURL)")
    }

    func testGetFullURL_MovieDetails() {
        let movieID = 123
        let expectedURL = "https://api.themoviedb.org/3/movie/\(movieID)"
        let result = APIManger.getFullURL(details: "movie", movieID: movieID)
        XCTAssertEqual(result, expectedURL, "The full URL for a specific movie with ID \(movieID) should be \(expectedURL)")
    }

    func testGetFullURL_Default() {
        let expectedURL = "https://api.themoviedb.org/3/movie/upcoming"
        let result = APIManger.getFullURL(details: "random")
        XCTAssertEqual(result, expectedURL, "The full URL should default to upcoming movies")
    }



}
