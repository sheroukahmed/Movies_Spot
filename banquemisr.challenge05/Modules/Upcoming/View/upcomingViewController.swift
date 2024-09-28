//
//  upcomingViewController.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import UIKit
import Network


class upcomingViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    let monitor = NWPathMonitor()
    var isConnected: Bool = false
    
    @IBOutlet weak var moviestable: UITableView!
    
    var upcomingVM : UpComingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upcomingVM = UpComingViewModel()
        
        upcomingVM?.bindResultToViewController = {
            DispatchQueue.main.async {
                print("Reloading table view with \(self.upcomingVM?.moviesResult?.count ?? 0) movies")
                self.moviestable.reloadData()
            }
        }
     
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            DispatchQueue.main.async {
                if self.isConnected {
                    self.upcomingVM?.loadData()
                } else {
                    self.upcomingVM?.loadDatafromCoreData()
                }
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        moviestable.dataSource = self
        moviestable.delegate = self
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        moviestable.register(nib, forCellReuseIdentifier: "moviecell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingVM?.moviesResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = moviestable.dequeueReusableCell(withIdentifier: "moviecell", for: indexPath) as? CustomTableViewCell else {
                    return UITableViewCell()
                }
        
        cell.movietitle.text = upcomingVM?.moviesResult?[indexPath.row].title
        cell.movielang.text = upcomingVM?.moviesResult?[indexPath.row].original_language
        if let releaseDate = upcomingVM?.moviesResult?[indexPath.row].release_date {
            let year = String(releaseDate.prefix(4))
            cell.movieyear.text = year
        } else {
            cell.movieyear.text = "N/A"
        }
        
        if let posterPath = upcomingVM?.moviesResult?[indexPath.row].poster_path {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            cell.movieImg.loadImage(from: imageUrl, placeholder: UIImage(named: "placeholder"))
        } else {
            cell.movieImg.image = UIImage(named: "placeholder")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailesStoryboard", bundle: nil)
        let detailesVC = storyboard.instantiateViewController(identifier: "detailesVC") as! MovieDetailesViewController
        
        detailesVC.movieDetailesVM = movieDetailesViewModel(movieId: upcomingVM?.moviesResult?[indexPath.row].id)
        
        
        detailesVC.modalPresentationStyle = .fullScreen
        detailesVC.modalTransitionStyle = .crossDissolve
       present(detailesVC, animated: true)
    }
    

   
}
