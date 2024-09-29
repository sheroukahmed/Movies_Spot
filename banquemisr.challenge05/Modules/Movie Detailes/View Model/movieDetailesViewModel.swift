//
//  movieDetailesViewModel.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import Foundation

class movieDetailesViewModel {
    var movieId : Int?
    var network : networkProtocol?
    var bindResultToViewController : (()->()) = {}
    
    var moviesResult :Movies? {
        didSet{
            bindResultToViewController()
        }
    }
    
    
    init(movieId : Int?) {
        self.network = Network()
        self.movieId = movieId
        
    }
    
    
    func loadData (){
        network?.fetch(url: APIManger.getFullURL(details: "movie",movieID: movieId ?? 0) ?? "", type: Movies.self, completionHandler: { [weak self] result, error in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
            }
            guard let result = result else {
                print("No result returned from the API")
                return
            }

            self?.moviesResult = result
            
            DispatchQueue.main.async {
                CoreDataManager.shared.storeMovie(currentMovie: result)
                
            }
            
        })
    }
    
    
    func loadDatafromCoreData() {
        CoreDataManager.shared.getMovie(completion: { storedMovies in
            guard let storedMovies = storedMovies else {
                print("Failed to fetch movies from Core Data")
                return
            }

            print("Loading \(storedMovies.count) movies from Core Data")

            for movieData in storedMovies {
                if let storedMovieId = movieData.value(forKey: "id") as? Int, storedMovieId == self.movieId {
                    var movie = Movies()
                    movie.backdrop_path = movieData.value(forKey: "backdrop_path") as? String
                    movie.original_language = movieData.value(forKey: "original_language") as? String
                    movie.overview = movieData.value(forKey: "overview") as? String
                    movie.poster_path = movieData.value(forKey: "poster_path") as? String
                    movie.release_date = movieData.value(forKey: "release_date") as? String
                    movie.original_title = movieData.value(forKey: "original_title") as? String
                    movie.vote_average = movieData.value(forKey: "vote_average") as? Double
                    movie.runtime = movieData.value(forKey: "runtime") as? Int
                    
                    if let genresString = movieData.value(forKey: "genres") as? String {
                        let genreNames = genresString.components(separatedBy: ", ")
                        movie.genres = genreNames.map { Genres(name: $0) }
                    }

                    self.moviesResult = movie
                    print("Loaded movie from Core Data: \(movie)")
                    break
                }
            }
        })
    }


    
}
