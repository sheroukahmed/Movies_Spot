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
            
            guard let result = result else{
               print(error)
                return
            }
            
            self?.moviesResult = result
            
        })
    }
}
