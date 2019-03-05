//
//  SearchTabViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/10/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class SearchTabViewController: UIViewController {

    // MARK: UI elements
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playContainer: UIView!
    var dataSongName = [String]()
    var dataArtist = [String]()
    var filterSongName = [String]()
    var filterArtistName = [String]()
    var isSearching : Bool = false
    
    // MARK: To do
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        customNavigationBar()
        loadDataSong()
        
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

    // MARK: Load Data
    func loadDataSong(){
        let (recommendedSong,recommendedArtist) = Song.splitSongArtistName(Songs: Song.recommendedSongs)
        let (USUKSong,USUKArtist) = Song.splitSongArtistName(Songs: Song.UsUkSongs)
        let (KPopSong,KPopArtist) = Song.splitSongArtistName(Songs: Song.KPopSongs)
        let (VPopSong,VPopArtist) = Song.splitSongArtistName(Songs: Song.VPopSongs)
        let (globalSong,globalArtist) = Song.splitSongArtistName(Songs: Song.globalSongs)

        for index in 0..<recommendedSong.count{
            dataSongName.append(recommendedSong[index])
            dataArtist.append(recommendedArtist[index])
        }
        for index in 0..<USUKSong.count{
            dataSongName.append(USUKSong[index])
            dataArtist.append(USUKArtist[index])
        }
        for index in 0..<KPopSong.count{
            dataSongName.append(KPopSong[index])
            dataArtist.append(KPopArtist[index])
        }
        for index in 0..<VPopSong.count{
            dataSongName.append(VPopSong[index])
            dataArtist.append(VPopArtist[index])
        }
        for index in 0..<globalSong.count{
            dataSongName.append(globalSong[index])
            dataArtist.append(globalArtist[index])
        }
    }
    
    // MARK: Custom NavigationBar
    private func customNavigationBar()
    {
        // Custom SearchBar
        searchBar.placeholder = "Search"
        searchBar.barStyle = .blackTranslucent
        
        navigationItem.titleView = searchBar
    }
    
    // MARK: --------KEYBOARD--------
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

// Table View Delegate
extension SearchTabViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false {
            return dataSongName.count
        }else{
            return filterSongName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
        if isSearching == false{
            cell.labelSongName.text = dataSongName[indexPath.row]
            cell.labelArtist.text = dataArtist[indexPath.row]
        }
        else {
            if filterSongName.count != 0 {
                cell.labelSongName.text = filterSongName[indexPath.row]

            }
            if filterArtistName.count != 0 {
                cell.labelArtist.text = filterArtistName[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        
        var fileNameSearch : String = ""
        fileNameSearch += cell.labelArtist.text!
        fileNameSearch += "-"
        fileNameSearch += cell.labelSongName.text!
        
        PlayScreenViewController.audioFileName = fileNameSearch
        PlayScreenViewController.list.removeAll()
        PlayScreenViewController.list.append(fileNameSearch)
        PlayScreenViewController.currentSong = 0
        PlayScreenViewController.song = Song.setSongName(with: PlayScreenViewController.audioFileName)
        PlayScreenViewController.artist = Song.setArtist(with: PlayScreenViewController.audioFileName)
        PlayScreenViewController.newSong = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        performSegue(withIdentifier: "playSegueFromSearch", sender: self)
        self.dismiss(animated: false, completion: nil)
    }
    
}

// MARK: Search Delegate
extension SearchTabViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            filterSongName.removeAll()
            filterArtistName.removeAll()
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else{
            isSearching = true
            
            filterSongName = dataSongName.filter({data ->Bool in
                guard let text = searchBar.text else {return false}
                return data.contains(text)
            })
            
            filterArtistName = Song.findArtistFromSongName(Songs: filterSongName)
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            filterSongName.removeAll()
            filterArtistName.removeAll()
            isSearching = false
            view.endEditing(true)
            searchBar.endEditing(true)
            searchBar.resignFirstResponder()
            tableView.reloadData()
    }
    
}
