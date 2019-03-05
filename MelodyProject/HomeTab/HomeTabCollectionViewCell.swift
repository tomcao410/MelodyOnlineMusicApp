//
//  HomeTabCollectionViewCell.swift
//  MelodyProject
//
//  Created by Tom on 12/12/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class HomeTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    
    
    static var song: String = ""
    
    
    func setSongFileName()
    {
        HomeTabCollectionViewCell.song = songName.text!
    }

    
    
    // MARK: Song name edit
    
}
