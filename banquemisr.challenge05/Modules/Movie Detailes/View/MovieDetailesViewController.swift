//
//  MovieDetailesViewController.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import UIKit
import Network

class MovieDetailesViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    var isConnected: Bool = false

    
    @IBOutlet weak var movieImg: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
   
    @IBOutlet weak var overview: UITextView!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var genre: UILabel!
    
    @IBOutlet weak var language: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    var movieDetailesVM : movieDetailesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailesVM?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let posterPath = self.movieDetailesVM?.moviesResult?.poster_path {
                    let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
                    self.movieImg.loadImage(from: imageUrl, placeholder: UIImage(named: "placeholder"))
                } else {
                    self.movieImg.image = UIImage(named: "placeholder")
                }
                
                self.movieTitle.text = self.movieDetailesVM?.moviesResult?.original_title ?? "N/A"
        
                self.overview.text = self.movieDetailesVM?.moviesResult?.overview ?? "N/A"
                
                if let voteAverage = self.movieDetailesVM?.moviesResult?.vote_average {
                    self.rating.text = String(format: "%.1f", voteAverage)
                } else {
                    self.rating.text = "N/A"
                }
                
                if let movieDuration = self.movieDetailesVM?.moviesResult?.runtime {
                    let hours = movieDuration / 60
                    let minutes = movieDuration % 60
                    self.duration.text = "\(hours)h \(minutes)m"
                } else {
                    self.duration.text = "N/A"
                }
                
                if let genres = self.movieDetailesVM?.moviesResult?.genres {
                    let genreNames = genres.compactMap { $0.name }.joined(separator: ", ")
                    self.genre.text = genreNames.isEmpty ? "N/A" : genreNames
                } else {
                    self.genre.text = "N/A"
                }
                
                self.language.text = self.movieDetailesVM?.moviesResult?.original_language?.uppercased() ?? "N/A"
                
                self.releaseDate.text = self.movieDetailesVM?.moviesResult?.release_date ?? "N/A"
            }
        }
        
        movieDetailesVM?.showErrorToViewController = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
            }
        }
        
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            DispatchQueue.main.async {
                if self.isConnected {
                    self.movieDetailesVM?.loadData()
                } else {
                    self.movieDetailesVM?.loadDatafromCoreData()
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
   
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
