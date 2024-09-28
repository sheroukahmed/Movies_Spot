//
//  Movie Model.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 27/09/2024.
//

import Foundation

struct Movies : Codable {
    var genres : [Genres]?
    var original_language : String?
    var original_title : String?
    var overview : String?
    var poster_path : String?
    var release_date : String?
    var runtime : Int?
    var vote_average : Double?
}

struct Genres : Codable {
    var name : String?
}
