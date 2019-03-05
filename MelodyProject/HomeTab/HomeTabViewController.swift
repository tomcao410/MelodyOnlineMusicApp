//
//  HomeTabViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/10/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import AVFoundation

class HomeTabViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playContainer: UIView!

    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()

        customNavigationBar()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayContainer()
    }
    
    // MARK: Custom NavigationBar
    private func customNavigationBar()
    {
        navigationItem.title = "Home"
    }
    
    // MARK: ContainerView
    private func displayContainer()
    {
        if PlayScreenViewController.audioPlayer == nil
        {
            playContainer.isHidden = true
        }
        else
        {
            playContainer.isHidden = false
        }
    }
}

// MARK: TableView
extension HomeTabViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let mycell = cell as? HomeTabTableViewCell{
            mycell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTabTableViewCell", for: indexPath) as! HomeTabTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch indexPath.row {
        case 0:
            cell.titleLbl.text = "Recommended"
        case 1:
            cell.titleLbl.text = "Top 5 US-UK"
        case 2:
            cell.titleLbl.text = "Top 5 V-Pop"
        case 3:
            cell.titleLbl.text = "Top 5 K-Pop"
        case 4:
            cell.titleLbl.text = "Top 5 Global"
        default:
            break
        }
        return cell
    }
    
}

// MARK: CollectionView
extension HomeTabViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTabCollectionViewCell", for: indexPath) as! HomeTabCollectionViewCell

        switch collectionView.tag {
        case 0:
            var item = Song.splitSongName(Songs: Song.recommendedSongs) as [String]
            cell.songName.text = item[indexPath.row]
        case 1:
            let item = Song.splitSongName(Songs: Song.UsUkSongs) as [String]
            cell.songName.text = item[indexPath.row]
        case 2:
            let item = Song.splitSongName(Songs: Song.VPopSongs) as [String]
            cell.songName.text = item[indexPath.row]
        case 3:
            let item = Song.splitSongName(Songs: Song.KPopSongs) as [String]
            cell.songName.text = item[indexPath.row]
        case 4:
            let item = Song.splitSongName(Songs: Song.globalSongs) as [String]
            cell.songName.text = item[indexPath.row]
        default:
            break
        }
        
        cell.songImage.image = #imageLiteral(resourceName: "mp3Icon")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        switch collectionView.tag {
        case 0:
            PlayScreenViewController.audioFileName = Song.recommendedSongs[indexPath.row]
            PlayScreenViewController.list = Song.recommendedSongs
            PlayScreenViewController.currentSong = indexPath.row
        case 1:
            PlayScreenViewController.audioFileName = Song.UsUkSongs[indexPath.row]
            PlayScreenViewController.list = Song.UsUkSongs
            PlayScreenViewController.currentSong = indexPath.row
        case 2:
            PlayScreenViewController.audioFileName = Song.VPopSongs[indexPath.row]
            PlayScreenViewController.list = Song.VPopSongs
            PlayScreenViewController.currentSong = indexPath.row
        case 3:
            PlayScreenViewController.audioFileName = Song.KPopSongs[indexPath.row]
            PlayScreenViewController.list = Song.KPopSongs
            PlayScreenViewController.currentSong = indexPath.row
        case 4:
            PlayScreenViewController.audioFileName = Song.globalSongs[indexPath.row]
            PlayScreenViewController.list = Song.globalSongs
            PlayScreenViewController.currentSong = indexPath.row
        default:
            break
        }
        
        // Set song name and artist
        PlayScreenViewController.song = Song.setSongName(with: PlayScreenViewController.audioFileName)
        PlayScreenViewController.artist = Song.setArtist(with: PlayScreenViewController.audioFileName)
        
        
        PlayScreenViewController.newSong = true
        performSegue(withIdentifier: "playSegueFromHome", sender: self)
    }
}
