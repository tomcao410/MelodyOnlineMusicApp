//
//  PopUpViewController.swift
//  MelodyProject
//
//  Created by Tom on 1/11/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var successLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successLbl.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    

    

}

extension PopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YourSongTabViewController.listOfPlayLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addToPlaylistCell", for: indexPath) as! PlaylistPopUpCollectionViewCell
        
        cell.playlist.text = YourPlayListViewController.playlists[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        YourSongTabViewController.listOfPlayLists[indexPath.row].append(PlayScreenViewController.song + "-" + PlayScreenViewController.artist)
        self.successLbl.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
}
