//
//  PhotoAlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-28.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var flickrPhoto: UIImageView!
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.activityViewIndicator.hidesWhenStopped = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
} // End PhotoAlbumCollectionViewCell
