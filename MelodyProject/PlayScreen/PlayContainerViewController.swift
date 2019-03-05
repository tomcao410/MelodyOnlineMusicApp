//
//  PlayContainerViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/12/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import AVFoundation
class PlayContainerViewController: UIViewController {

    // MARK: UI elements
    @IBOutlet weak var songInfo: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    //static var isSongBeingPlayed: Bool = false
    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Show Play screen
        showPlayScreenWhenTapped()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set UI
        setUI()
        
        if PlayScreenViewController.isPlaying == true
        {
            playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
        }
        else
        {
            playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
        }
    }
    
    // MARK: Set UI
    func setUI()
    {
        songInfo.text = PlayScreenViewController.song + " - " + PlayScreenViewController.artist
    }
    // MARK: Tap on container view
    func showPlayScreenWhenTapped()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissContainerView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissContainerView()
    {
        self.dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "playSegueFromContainerView", sender: self)
    }
    
    // MARK: BUTTON clicked
    @IBAction func playButtonClicked(_ sender: Any) {
        if PlayScreenViewController.audioPlayer != nil
        {
            // Stop
            if PlayScreenViewController.isPlaying == true
            {
                playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
                PlayScreenViewController.isPlaying = false
                PlayScreenViewController.audioPlayer.stop()
            }
            // Play
            else
            {
                //PlayContainerViewController.isSongBeingPlayed = true
                playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
                PlayScreenViewController.isPlaying = true
                PlayScreenViewController.audioPlayer.prepareToPlay()
                PlayScreenViewController.audioPlayer.play()
            }
        }
    }
}
