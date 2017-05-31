//
//  FilterCell.swift
//  Filterer
//
//  Created by Daniel Alejandro Carriola on 30.05.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // Add image to cell
    func configureCell(withFilter filter: FilterName) {
        imageView.image = UIImage(named: "\(filter.hashValue)")
    }
}
