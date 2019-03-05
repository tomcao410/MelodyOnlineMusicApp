//
//  SearchTableViewCell.swift
//  MelodyProject
//
//  Created by Tom on 1/5/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSongName: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
