//
//  APIManger.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import Foundation

class APIManger {
    
    static let base = "https://api.themoviedb.org/3/movie/"
    
    enum endpoints : String{
        case upcomming = "upcoming"
        case nowplaying = "now_playing"
        case popular = "popular"
    }
    
    
    static func getFullURL(details: String , movieID : Int = 0) -> String? {
        switch details {
        case endpoints.upcomming.rawValue:
            return base + endpoints.upcomming.rawValue
        case endpoints.popular.rawValue:
            return base + endpoints.popular.rawValue
        case endpoints.nowplaying.rawValue:
            return base + endpoints.nowplaying.rawValue
        case "movie":
            return base + String(movieID) 
        default:
            return base + endpoints.upcomming.rawValue
        }
        
    }
}
