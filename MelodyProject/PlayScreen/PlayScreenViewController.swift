//
//  PlayScreenViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/12/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import MediaPlayer

class PlayScreenViewController: UIViewController {

    
    // MARK: UI elements
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var artistName: UIButton!
    @IBOutlet weak var lyricsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var popUpView: UIView!
    
    static var audioPlayer: AVAudioPlayer!
    var timer: Timer?
    var min: Int = Int()
    var sec: Int = Int()
    static var newSong: Bool = false
    static var isPlaying: Bool = false
    static var audioFileName: String = ""
    static var artist: String = "Unknown artist"
    static var song: String = "Song name"
    var lyricsWillShow: Bool = false
    
    static var list: [String] = [String]()
    var songShouldPlay: Int = -1
    
    static var currentSong: Int = 0
    
    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
        //playAudioWith(fileName: Song.songs[currentSong], fileExtension: "mp3")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Stop the current song when play screen appear
        if PlayScreenViewController.newSong == true
        {
            downloadAudio()
            PlayScreenViewController.newSong = false
        }
        else if PlayScreenViewController.audioPlayer != nil
        {
            setPlayScreenUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        PlayScreenViewController.song = songName.text!
        PlayScreenViewController.artist = artistName.currentTitle!
        
        self.dismiss(animated: false, completion: nil)
    }
    func setUpSongArtist()
    {
        artistName.setTitle(PlayScreenViewController.artist, for: .normal)
        songName.text = PlayScreenViewController.song
    }
    
    func setPlayScreenUI(){
        // Slider
        self.slider.maximumValue = Float(PlayScreenViewController.audioPlayer.duration)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (self.changeSliderValueDueToCurrentTime), userInfo: nil, repeats: true)
        
        // Spinner
        self.spinner.stopAnimating()
        
        // Label and Button
        songName.text = PlayScreenViewController.song
        artistName.setTitle(PlayScreenViewController.artist, for: .normal)
        
        // Time Label
        syncTimeLabelWithSongCurrentTime()
        
        // Play Button
        if PlayScreenViewController.isPlaying == false
        {
            playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
        }
        else
        {
            playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
        }
        
        // Enable buttons
        artistName.isEnabled = true
        lyricsButton.isEnabled = true
        slider.isEnabled = true
        playButton.isEnabled = true
        forwardButton.isEnabled = true
        rewindButton.isEnabled = true
        addButton.isEnabled = true
        
        if self.songShouldPlay == PlayScreenViewController.list.count - 1 {
            self.forwardButton.isEnabled = false
        }
        else if self.songShouldPlay == 0 {
            self.rewindButton.isEnabled = false
        }
        
        
    }
    
    // MARK: Download Audio
    func downloadAudio()
    {
        downloading()
        
        let storage = Storage.storage()
        let rootFolder = storage.reference(forURL: "gs://melodyproject-8331a.appspot.com")
        //let audioFolder = rootFolder.child("Global")
        let audioFile = rootFolder.child(PlayScreenViewController.audioFileName + ".mp3")
        //let audioData = NSData(contentsOf: Bundle.main.url(forResource: "BIGBANG-If You", withExtension: "mp3")!)
        
        audioFile.getData(maxSize: 7 * 1024 * 1024) { (data: Data?, error: Error?) in
            if error != nil
            {
                print("\(error!.localizedDescription)")
            }
            else
            {
                
                do{
                    try PlayScreenViewController.audioPlayer = AVAudioPlayer(data: data!)
                    
                    // Play audio
                    PlayScreenViewController.audioPlayer.prepareToPlay()
                    PlayScreenViewController.audioPlayer.delegate = self
                    PlayScreenViewController.audioPlayer.play()
                    PlayScreenViewController.isPlaying = true
                    self.setUpSongArtist()
                    // Set UI
                    self.setPlayScreenUI()
                    
                    
                    // Play audio in LockScreen
                    self.playInLockScreen()
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func downloading()
    {
        slider.value = 0
        durationTime.text = "00:00"
        spinner.startAnimating()
        
        // Disable buttons
        artistName.isEnabled = false
        lyricsButton.isEnabled = false
        slider.isEnabled = false
        playButton.isEnabled = false
        forwardButton.isEnabled = false
        rewindButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    // MARK: PLAY AUDIO FILE
    /*func playAudioWith(fileName: String, fileExtension: String)
    {
        slider.minimumValue = 0
        if let mp3String = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        {
            let url = NSURL(fileURLWithPath: mp3String)
            do
            {
                PlayScreenViewController.audioPlayer = try AVAudioPlayer(contentsOf: url as URL, fileTypeHint: fileExtension)
                
                // Slider
                slider.maximumValue = Float(PlayScreenViewController.audioPlayer.duration)
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (changeSliderValueDueToCurrentTime), userInfo: nil, repeats: true)
                
                // Set song name and artist
                artistName.setTitle(Song.songArtist[currentSong], for: .normal)
                songName.text = Song.songName[currentSong]
                
                // Play audio
                PlayScreenViewController.audioPlayer.prepareToPlay()
                PlayScreenViewController.audioPlayer.delegate = self
                PlayScreenViewController.audioPlayer.play()
                PlayScreenViewController.isPlaying = true
                
                // Play audio in LockScreen
                playInLockScreen()
            }catch{
                print("\(error.localizedDescription)")
            }
        }
    }*/
    
    func playInLockScreen()
    {
        /*let songImage = MPMediaItemArtwork(image: #imageLiteral(resourceName: "mp3Icon"))
        MPNowPlayingInfoCenter.default().nowPlayingInfo =
            [MPMediaItemPropertyTitle: Song.songs[currentSong],
             MPMediaItemPropertyArtist: "Alec Benjamin",
             MPMediaItemPropertyPlaybackDuration: PlayScreenViewController.audioPlayer.duration,
             MPMediaItemPropertyArtwork: songImage]
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()*/
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event
        {
            if event.type == .remoteControl
            {
                switch event.subtype
                {
                case .remoteControlPlay:
                    PlayScreenViewController.audioPlayer.play()
                case .remoteControlPause:
                    PlayScreenViewController.audioPlayer.stop()
                case .remoteControlNextTrack:
                    print("Next track function isn't available at the moment!")
                case .remoteControlPreviousTrack:
                    print("Previous track function isn't available at the moment!")
                default:
                    print("Default function isn't available at the moment!")
                }
            }
        }
    }
    
    
    // MARK: SLIDER (time)
    @objc func changeSliderValueDueToCurrentTime()
    {
        let currentValue = Float(PlayScreenViewController.audioPlayer.currentTime)
        slider.value = currentValue
        syncTimeLabelWithSongCurrentTime()
    }
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        syncTimeLabelWithSongCurrentTime()
        
        if PlayScreenViewController.audioPlayer.isPlaying == true
        {
            PlayScreenViewController.audioPlayer.stop()
            let currentTime = slider.value
            PlayScreenViewController.audioPlayer.currentTime = TimeInterval(currentTime)
            PlayScreenViewController.audioPlayer.prepareToPlay()
            PlayScreenViewController.audioPlayer.play()
        }
        else
        {
            let currentTime = slider.value
            PlayScreenViewController.audioPlayer.currentTime = TimeInterval(currentTime)
        }
    }
    
    // MARK: TIME LABELS
    func syncTimeLabelWithSongCurrentTime()
    {
        // Duration time label
        min = Int(PlayScreenViewController.audioPlayer.duration / 60)
        sec = Int(PlayScreenViewController.audioPlayer.duration) - (min * 60)
        if sec < 10
        {
            durationTime.text = "\(min):0\(sec)"
        }
        else
        {
            durationTime.text = "\(min):\(sec)"
        }
        
        
        // Current time label
        min = Int(PlayScreenViewController.audioPlayer.currentTime / 60)
        sec = Int(PlayScreenViewController.audioPlayer.currentTime) - (min * 60)
        if min < 10 && sec < 10
        {
            currentTime.text = "0\(min):0\(sec)"
        }
        else if min > 10 && sec < 10
        {
            currentTime.text = "\(min):0\(sec)"
        }
        else if min < 10 && sec > 10
        {
            currentTime.text = "0\(min):\(sec)"
        }
    }
    
    // MARK: BUTTONS
    @IBAction func rewindButtonClicked(_ sender: Any) {
        PlayScreenViewController.currentSong -= 1
        songShouldPlay = PlayScreenViewController.currentSong
        
        if PlayScreenViewController.list.count != 1
        {
            // Start current song
            if slider.value >= 5 {
                if songShouldPlay < PlayScreenViewController.list.count{
                    PlayScreenViewController.audioPlayer.currentTime = 0
                    PlayScreenViewController.audioPlayer.play()
                    slider.value = 0
                }
            }
                // Previous song
                
            else if songShouldPlay >= 0 {
                PlayScreenViewController.audioPlayer.stop()
                PlayScreenViewController.audioFileName = PlayScreenViewController.list[songShouldPlay]
                downloadAudio()
                PlayScreenViewController.song = Song.setSongName(with: PlayScreenViewController.audioFileName)
                PlayScreenViewController.artist = Song.setArtist(with: PlayScreenViewController.audioFileName)
            }
        }
        else {
            PlayScreenViewController.audioPlayer.currentTime = 0
            PlayScreenViewController.audioPlayer.play()
            slider.value = 0
        }
        
        
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        if PlayScreenViewController.audioPlayer.isPlaying == false
        {
            playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
            PlayScreenViewController.audioPlayer.prepareToPlay()
            PlayScreenViewController.audioPlayer.play()
            
            // Set global element
            PlayScreenViewController.isPlaying = true
        }
        else
        {
            playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
            PlayScreenViewController.audioPlayer.stop()
            syncTimeLabelWithSongCurrentTime()
            
            PlayScreenViewController.isPlaying = false
        }
    }
    
    @IBAction func fastForwardButtonClicked(_ sender: Any) {
        
        //Next Song
        PlayScreenViewController.currentSong += 1
        songShouldPlay = PlayScreenViewController.currentSong
        if songShouldPlay < PlayScreenViewController.list.count {
            PlayScreenViewController.audioPlayer.stop()
            PlayScreenViewController.audioFileName = PlayScreenViewController.list[songShouldPlay]
            downloadAudio()
            slider.value = 0
        }
        else {
            PlayScreenViewController.audioPlayer.currentTime = 0
            PlayScreenViewController.audioPlayer.play()
            slider.value = 0
        }
        
        if PlayScreenViewController.list.count == 1
        {
            PlayScreenViewController.audioPlayer.currentTime = 0
            PlayScreenViewController.audioPlayer.play()
            slider.value = 0
        }
        
        // Set song name and artist
        PlayScreenViewController.song = Song.setSongName(with: PlayScreenViewController.audioFileName)
        PlayScreenViewController.artist = Song.setArtist(with: PlayScreenViewController.audioFileName)
        
    }
    
    @IBAction func lyricsButtonClicked(_ sender: Any) {
        //lyricsWillShow = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        performSegue(withIdentifier: "showLyrics", sender: self)
    }

    @IBAction func artistInfoButtonClicked(_ sender: Any) {
        ArtistInfoViewController.artist = (artistName.titleLabel?.text)!
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        performSegue(withIdentifier: "showArtistInfo", sender: self)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "popUpSegue", sender: self)
    }
    
    
}

extension PlayScreenViewController: AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag
        {
            PlayScreenViewController.audioPlayer.stop()
            songShouldPlay = PlayScreenViewController.currentSong
            
            if PlayScreenViewController.currentSong == 4
            {
                PlayScreenViewController.currentSong = 0
            }
            else
            {
                PlayScreenViewController.currentSong += 1
            }
            
            // Play the next song
            songShouldPlay = PlayScreenViewController.currentSong
            PlayScreenViewController.audioFileName = PlayScreenViewController.list[songShouldPlay]
            downloadAudio()
            
            // Set song name and artist
            PlayScreenViewController.song = Song.setSongName(with: PlayScreenViewController.audioFileName)
            PlayScreenViewController.artist = Song.setArtist(with: PlayScreenViewController.audioFileName)
        }
    }
    
    
}
