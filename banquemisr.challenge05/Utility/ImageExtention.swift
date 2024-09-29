//
//  ImageExtention.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 27/09/2024.
//

import Foundation

import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
            self.image = placeholder
            
            guard let url = URL(string: urlString) else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.image = placeholder
                    }
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.image = placeholder
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            
            task.resume()
        }
}
