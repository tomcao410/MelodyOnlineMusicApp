//
//  ArtistInfoViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/13/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class ArtistInfoViewController: UIViewController {

    // MARK: UI elements
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listSongs = [String]()
    
    static var artist : String = ""
    static var numberOfSongs: Int = 0
    
    // MARK: To do
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        processingData()

        customNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customNavigationBar()
    }
    
    private func processingData()
    {
        artistName.text = ArtistInfoViewController.artist
        addSongNameOfArtist(Songs: Song.recommendedSongs)
        addSongNameOfArtist(Songs: Song.KPopSongs)
        addSongNameOfArtist(Songs: Song.VPopSongs)
        addSongNameOfArtist(Songs: Song.globalSongs)
        addSongNameOfArtist(Songs: Song.UsUkSongs)
        
    }
    
    private func addSongNameOfArtist(Songs: [String])
    {
        for i in 0..<Songs.count {
            let temp : String = Song.setArtist(with: Songs[i])
            if temp == ArtistInfoViewController.artist {
                listSongs.append(Song.setSongName(with: Songs[i]))
            }
        }
    }
    
    private func customNavigationBar()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Change artist photo
    private func photoPickerController()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true)
    }
    
    @IBAction func changeImageClicked(_ sender: Any) {
        photoPickerController()
    }
    
    
}

// MARK: Collection View
extension ArtistInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistSongsCell", for: indexPath) as! ArtistSongsCollectionViewCell
        
        cell.songImage.image = #imageLiteral(resourceName: "mp3Icon")
        cell.songName.text = listSongs[indexPath.row]
        
        return cell
    }
}


extension ArtistInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage
        {
            self.artistImage.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
