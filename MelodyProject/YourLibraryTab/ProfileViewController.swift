//
//  ProfileViewController.swift
//  MelodyProject
//
//  Created by Tom on 12/13/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    // MARK: UI elements
    @IBOutlet weak var playContainer: UIView!
    
    // MARK: To do
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


    
    @IBAction func handleLogOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        if PlayScreenViewController.audioPlayer != nil
        {
            PlayScreenViewController.audioPlayer.stop()
        }
        
        self.dismiss(animated: false, completion: nil)
        self.hidesBottomBarWhenPushed = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        performSegue(withIdentifier: "logOutSegue", sender: self)
    
    }
    
}
