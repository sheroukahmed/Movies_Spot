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
    var original_language : String?
    var title : String?
    var poster_path : String?
    var release_date: String?
}
