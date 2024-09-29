//
//  nowplayingViewController.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import UIKit
import Network

class MovieListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    let monitor = NWPathMonitor()
    var isConnected: Bool = false

    @IBOutlet weak var moviestable: UITableView!

    var viewModel : TabBarViewModel?

    override func viewDidLoad() {
           super.viewDidLoad()

        moviestable.dataSource = self
        moviestable.delegate = self

        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        moviestable.register(nib, forCellReuseIdentifier: "moviecell")

        self.tabBarController?.tabBar.items?[0].title = "Now Playing"
        self.tabBarController?.tabBar.items?[0].selectedImage = UIImage(named: "tv")
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "tv")

        self.tabBarController?.tabBar.items?[1].title = "Popular"
        self.tabBarController?.tabBar.items?[1].selectedImage = UIImage(named: "favorite")
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "favorite")


        self.tabBarController?.tabBar.items?[2].title = "UpComing"
        self.tabBarController?.tabBar.items?[2].selectedImage = UIImage(named: "upcoming")
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "upcoming")


        switch self.tabBarController?.tabBar.selectedItem?.title {
        case "Now Playing":
            viewModel = TabBarViewModel(screenType: "now_playing", entityType: "NowPlaying")
        case "Popular":
            viewModel = TabBarViewModel(screenType: "popular", entityType: "Popular")
        case "UpComing":
            viewModel = TabBarViewModel(screenType: "upcoming", entityType: "Upcoming")
        default:
            viewModel = TabBarViewModel(screenType: "upcoming", entityType: "Upcoming")

        }

           viewModel?.bindResultToViewController = {
               DispatchQueue.main.async {
                   print("Reloading table view with \(self.viewModel?.moviesResult?.count ?? 0) movies")
                   self.moviestable.reloadData()
               }
           }

           monitor.pathUpdateHandler = { path in
               self.isConnected = (path.status == .satisfied)
               DispatchQueue.main.async {
                   if self.isConnected {
                       self.viewModel?.loadData()
                   } else {
                       self.viewModel?.loadDatafromCoreData()
                      
                   }
               }
           }

           let queue = DispatchQueue(label: "NetworkMonitor")
           monitor.start(queue: queue)


       }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.moviesResult?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = moviestable.dequeueReusableCell(withIdentifier: "moviecell", for: indexPath) as? CustomTableViewCell else {
                    return UITableViewCell()
                }

        cell.movietitle.text = viewModel?.moviesResult?[indexPath.row].title
        cell.movielang.text = viewModel?.moviesResult?[indexPath.row].original_language
        if let releaseDate = viewModel?.moviesResult?[indexPath.row].release_date {
            let year = String(releaseDate.prefix(4))
            cell.movieyear.text = year
        } else {
            cell.movieyear.text = "N/A"
        }

        if let posterPath = viewModel?.moviesResult?[indexPath.row].poster_path {
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
        

        detailesVC.movieDetailesVM = movieDetailesViewModel(movieId: viewModel?.moviesResult?[indexPath.row].id)
        
        detailesVC.modalPresentationStyle = .fullScreen
        detailesVC.modalTransitionStyle = .crossDissolve
       present(detailesVC, animated: true)
    }


}
