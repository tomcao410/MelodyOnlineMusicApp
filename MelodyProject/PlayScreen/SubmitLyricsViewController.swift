//
//  SubmitLyricsViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/13/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class SubmitLyricsViewController: UIViewController {

    @IBOutlet weak var lyricsSubmitted: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss keyboard when tap anywhere outside the textview
        hideKeyboard()
    }
    
    
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
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        LyricsScreenViewController.lyrics = lyricsSubmitted.text!

        navigationController?.popViewController(animated: false)
    }
    
    

}
