//
//  YourSongsViewController.swift
//  MelodyProject
//
//  Created by Tom on 1/1/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class YourPlayListViewController: UIViewController {
    
    // MARK: UI elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playContainer: UIView!
    
    static var playlists : [String] = ["MyPlaylist", "Favorite"]
    
    // MARK: To do
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()

        customNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayContainer()
    }
    
    // MARK: Custom Navigation Bar
    private func customNavigationBar()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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


extension YourPlayListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YourPlayListViewController.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourPlayListCell", for: indexPath) as! YourPlayListTableViewCell
        
        cell.playlist.text = YourPlayListViewController.playlists[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
        //let cell = tableView.cellForRow(at: indexPath)
        YourSongTabViewController.playlistName = YourPlayListViewController.playlists[indexPath.row]
        performSegue(withIdentifier: "songSegueFromPlayList", sender: self)
    }
    
}
