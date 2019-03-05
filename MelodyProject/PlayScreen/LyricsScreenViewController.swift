//
//  LyricsScreenViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/13/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class LyricsScreenViewController: UIViewController {

    
    @IBOutlet weak var lyricsLbl: UILabel!
    
    static var lyrics: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customLyrics()
    }
    
   
    private func customNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain
            , target: self, action: #selector (submitTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
  
    private func customLyrics()
    {
        if LyricsScreenViewController.lyrics != ""
        {
            lyricsLbl.text = LyricsScreenViewController.lyrics
        }
    }
    
    @objc func submitTapped()
    {
        performSegue(withIdentifier: "showSubmitLyricsScreen", sender: self)
    }
    

}
