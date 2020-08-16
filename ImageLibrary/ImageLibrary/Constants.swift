//
//  Constants.swift
//  ImageLibrary
//
//  Created by user178197 on 8/13/20.
//  Copyright © 2020 user178197. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct  PhotoCollectionView {
        static let itemsPerRow: CGFloat = 2
        static let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    struct Endpoints {
        static let BaseUrl = "https://pastebin.com"
        static let getPath = "/raw/wgkJgazE"
    }
    
    struct PhotoCell {
        static let cellIdentifier = "photoCell"
    }
    
}
