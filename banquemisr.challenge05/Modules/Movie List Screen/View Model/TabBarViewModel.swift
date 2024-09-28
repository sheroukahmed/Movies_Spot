//
//  nowplayingViewModel.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import Foundation

class TabBarViewModel {
    
    var network: networkProtocol?
    var bindResultToViewController: (() -> Void) = {}
    var screenType : String?
    var entityType : String?
    
    var moviesResult: [EventMovie]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    init(screenType : String? , entityType : String? ) {
        self.network = Network()
        self.screenType = screenType
        self.entityType = entityType
    }
    
    func loadData() {
        network?.fetch(url: APIManger.getFullURL(details: screenType ?? "") ?? "", type: EventResponse.self, completionHandler: { [weak self] result, error in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
            }
            
            guard let result = result else {
                print("No result returned from the API")
                return
            }
            
            print("Fetched \(result.results?.count ?? 0) movies from the API")
            
            self?.moviesResult = result.results ?? []
            
            CoreDataManager.shared.deleteAllMovies(EnityValue: self?.entityType ?? "")
            
            if let movies = result.results {
                for movie in movies {
                    CoreDataManager.shared.storeEvent(Event: movie, EnityValue: self?.entityType ?? "")
                }
            }
        })
    }
    
    func loadDatafromCoreData() {
        let storedMovies = CoreDataManager.shared.getEvent(EnityValue: self.entityType ?? "")
        print("Loading \(storedMovies.count) movies from Core Data")
        
        self.moviesResult = []
        
        for movieData in storedMovies {
            var movie = EventMovie()
            movie.backdrop_path = movieData.value(forKey: "backdrop_path") as? String
            movie.original_language = movieData.value(forKey: "original_language") as? String
            movie.overview = movieData.value(forKey: "overview") as? String
            movie.poster_path = movieData.value(forKey: "poster_path") as? String
            movie.release_date = movieData.value(forKey: "release_date") as? String
            movie.title = movieData.value(forKey: "title") as? String
            movie.vote_average = movieData.value(forKey: "vote_average") as? Double

            self.moviesResult?.append(movie)
        }
        
        print("Movies loaded into view model: \(self.moviesResult?.count ?? 0)")
        self.bindResultToViewController()
    }
}
