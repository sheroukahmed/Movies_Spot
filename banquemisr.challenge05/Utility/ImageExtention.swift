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
        
        DispatchQueue.global().async {
            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
