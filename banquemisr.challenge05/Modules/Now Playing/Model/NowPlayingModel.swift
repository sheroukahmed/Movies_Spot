//
//  NowPlayingModel.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 27/09/2024.
//

import Foundation

struct NowPlayingResponse : Codable {
    var results : [NowPlaying]?
}

struct NowPlaying : Codable{
    var original_language : String?
    var title : String?
    var poster_path : String?
    var release_date: String?
}
