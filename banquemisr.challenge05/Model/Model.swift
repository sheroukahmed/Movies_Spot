//
//  NowPlayingModel.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 27/09/2024.
//

import Foundation

struct EventResponse : Codable {
    var results : [EventMovie]?
}

struct EventMovie : Codable{
    var id : Int?
    var original_language : String?
    var title : String?
    var poster_path : String?
    var release_date: String?
    var backdrop_path: String?
    var overview : String?
    var vote_average : Double?
    
}
