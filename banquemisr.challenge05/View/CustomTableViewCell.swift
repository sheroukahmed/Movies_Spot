//
//  CustomTableViewCell.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 26/09/2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImg: UIImageView!
    
    @IBOutlet weak var movietitle: UILabel!
    
    @IBOutlet weak var movieyear: UILabel!
    
    @IBOutlet weak var movielang: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
