//
//  nowplayingViewModel.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import Foundation

class NowPlayingViewModel {
    
    var network : networkProtocol?
    var bindResultToViewController : (()->()) = {}
    
    var moviesResult :[NowPlaying]? {
        didSet{
            bindResultToViewController()
        }
    }
    
    
    init() {
        self.network = Network()
    }
    
    
    func loadData (){
        network?.fetch(url: APIManger.getFullURL(details: "now_playing") ?? "", type: NowPlayingResponse.self, completionHandler: { [weak self] result, error in
            
            guard let result = result else{
               print(error)
                return
            }
            
            self?.moviesResult = result.results
            
        })
    }
}
