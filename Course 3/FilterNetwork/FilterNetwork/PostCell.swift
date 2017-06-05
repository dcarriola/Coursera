//
//  PostCell.swift
//  FilterNetwork
//
//  Created by Daniel Alejandro Carriola on 05.06.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoView.clipsToBounds = true
    }

    // Add info to cell
    func configureCell(withPost post: Post) {
        let image = post.like == true ? UIImage(named: "heart-full") : UIImage(named: "heart-empty")
        likeImg.image = image
        
        if let data = Data(base64Encoded: post.image!, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: data)
            photoView.image = image
        }
    }

}
