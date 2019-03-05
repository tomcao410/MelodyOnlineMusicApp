//
//  YourLibraryTabViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/10/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class YourSongTabViewController: UIViewController {

    // MARK: UI elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playContainer: UIView!
    
    static var listOfPlayLists: [String] = ["MyPlaylist", "Favorite"]
    
    static var MyPlaylist : [String] = ["iKON-Killing Me",
                                        "JENNIE-SOLO",
                                        "LyLy-24H",
                                        "Den Vau-Do Em Biet Anh Dang Nghi Gi"]
    static var Favorite : [String] = ["Khalid-Love Lies",
                                      "Mino-Fiance",
                                      "Huong Giang-Anh Dang O Dau Day Anh",
                                      "Camila Cabello-Beautiful",
                                      "BIGBANG-If You",
                                      "Son Tung MTP-Lac Troi"]
    
    static var playlistName : String = ""
    
    // MARK: To do
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        customNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayContainer()
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
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    // MARK: Custom Navigation Bar
    private func customNavigationBar()
    {
        navigationItem.title = YourSongTabViewController.playlistName
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension YourSongTabViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if YourSongTabViewController.playlistName == "MyPlaylist"{
            return YourSongTabViewController.MyPlaylist.count
        }
        else if YourSongTabViewController.playlistName == "Favorite"{
            return YourSongTabViewController.Favorite.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourLibraryCell", for: indexPath) as! YourSongTabTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.songImage.image = #imageLiteral(resourceName: "mp3Icon")
        
        if YourSongTabViewController.playlistName == "MyPlaylist"{
            cell.songArtist.text = Song.setArtist(with: YourSongTabViewController.MyPlaylist[indexPath.row])
            cell.songName.text = Song.setSongName(with: YourSongTabViewController.MyPlaylist[indexPath.row])
        }
        else if YourSongTabViewController.playlistName == "Favorite"{
            cell.songArtist.text = Song.setArtist(with: YourSongTabViewController.Favorite[indexPath.row])
            cell.songName.text = Song.setSongName(with: YourSongTabViewController.Favorite[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let cell = tableView.cellForRow(at: indexPath) as! YourSongTabTableViewCell
        
        var fileName : String = ""
        fileName += cell.songArtist.text!
        fileName += "-"
        fileName += cell.songName.text!
        
        PlayScreenViewController.audioFileName = fileName
        PlayScreenViewController.list.removeAll()
        
        if YourSongTabViewController.playlistName == "MyPlaylist"{
            PlayScreenViewController.list = YourSongTabViewController.MyPlaylist
        }
        else if YourSongTabViewController.playlistName == "Favorite"{
            PlayScreenViewController.list = YourSongTabViewController.Favorite
        }
        
        PlayScreenViewController.currentSong = indexPath.row
        
        PlayScreenViewController.song = cell.songName.text!
        PlayScreenViewController.artist = cell.songArtist.text!
        PlayScreenViewController.newSong = true
        performSegue(withIdentifier: "playSegueFromYourLibrary", sender: self)
    }
    
    // MARK: Edit
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if YourSongTabViewController.playlistName == "MyPlaylist"{
            let movedSong = YourSongTabViewController.MyPlaylist[sourceIndexPath.item]
            YourSongTabViewController.MyPlaylist.remove(at: sourceIndexPath.item)
            YourSongTabViewController.MyPlaylist.insert(movedSong, at: destinationIndexPath.item)
        }
        else if YourSongTabViewController.playlistName == "Favorite"{
            let movedSong = YourSongTabViewController.Favorite[sourceIndexPath.item]
            YourSongTabViewController.Favorite.remove(at: sourceIndexPath.item)
            YourSongTabViewController.Favorite.insert(movedSong, at: destinationIndexPath.item)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            if YourSongTabViewController.playlistName == "MyPlaylist"{
                YourSongTabViewController.MyPlaylist.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            else if YourSongTabViewController.playlistName == "Favorite"{
                YourSongTabViewController.Favorite.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
}
